//
//  UserService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.11.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserServiceProtocol {
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error>
    func likeUser(userID: String, uid: String) async -> Result<Void, Error>
    func dislikeUser(userID: String, uid: String) async -> Result<Void, Error>
    func blockUser(userID: String, uid: String) async -> Result<Void, Error>
    
    func fetchAccount(userID: String) async -> Result<(UserModel, QueryDocumentSnapshot?), Error>
    func updateAccount(userID: String, updateField: [String: Any]) async -> Result<Void, Error>
    func signOut(userID: String) async -> Result<Void, Error>
    func deleteAccount() async -> Result<Void, Error>
    func deleteAccountData(userID: String) async -> Result<Void, Error>
    func updateOnlineState( userID: String, online: Bool, lastVisit: Date? ) async -> Result<Void, Error>
    func fetchBlockedUsers(userID: String, lastUser: QueryDocumentSnapshot?) async -> Result<([BlockedUserModel], QueryDocumentSnapshot?), Error>
}

class UserService {
    static let shared: UserServiceProtocol = UserService()
    let db = Firestore.firestore()
    private init() { }
}

extension UserService: UserServiceProtocol {
    func fetchBlockedUsers(userID: String, lastUser: QueryDocumentSnapshot?) async -> Result<([BlockedUserModel], QueryDocumentSnapshot?), Error> {
        do {
            let usersDocs = try await db.collection("Users").document(userID).collection("Blocked").getDocuments().documents
            let users = try usersDocs.map{ try $0.data(as: BlockedUserModel.self)}
            return .success((users, usersDocs.last))
        } catch {
            return .failure(error)
        }
    }
    
    func updateOnlineState(userID: String, online: Bool, lastVisit: Date?) async -> Result<Void, Error> {
        do {
            try await db.collection("Users").document(userID).setData(["online": online,
                                                                       "lastVisit": lastVisit], merge: true)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func signOut(userID: String) async -> Result<Void, Error> {
        do {
            try await db.collection("Users").document(userID).setData(["online": false,
                                                                       "lastVisit": Date().toGlobalTime()], merge: true)
            try Auth.auth().signOut()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAccount() async -> Result<Void, Error> {
        do {
            try await Auth.auth().currentUser?.delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAccountData(userID: String) async -> Result<Void, Error> {
        do {
            try await db.collection("Users").document(userID).delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func updateAccount(userID: String, updateField: [String: Any]) async -> Result<Void, Error> {
        do {
            try await db.collection("Users").document(userID).setData(updateField, merge: true)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchAccount(userID: String) async -> Result<(UserModel, QueryDocumentSnapshot?), Error> {
        do {
            var user = try await db.collection("Users").document(userID).getDocument().data(as: UserModel.self)
            let posts = try await db.collection("Blogs")
                .whereField("user.id", isEqualTo: userID)
                .order(by: "createdAt", descending: true)
                .limit(to: 10)
                .getDocuments().documents
            
            user.posts = try posts.map{ try $0.data(as: PostModel.self)}
            
            return .success((user, posts.last))
        } catch {
            return .failure(error)
        }
    }
    
    func dislikeUser(userID: String, uid: String) async -> Result<Void, Error> {
        do {
            let myEncodedRequests = try await db.collection("Users").document(userID).getDocument().get("requests")
            var myRequests = [String]()
            if let myEncodedRequests {
                myRequests = try Firestore.Decoder().decode([String].self, from: myEncodedRequests)
            }
            
            if myRequests.contains(uid) {
                // if I dislike user
                // remove from requests and add to dislikes
                // remove user's pending request as I dislik
                try await db.collection("Users").document(userID).updateData(["requests" : FieldValue.arrayRemove([uid])])
                try await db.collection("Users").document(userID).updateData(["dislikes" : FieldValue.arrayUnion([uid])])
                try await db.collection("Users").document(uid).updateData(["pending" : FieldValue.arrayRemove([userID])])

            } else {
                try await db.collection("Users").document(userID).updateData(["dislikes" : FieldValue.arrayUnion([uid])])
            }
            
            return .success(())

        } catch {
            return .failure(error)
        }
    }
    
    func likeUser(userID: String, uid: String) async -> Result<Void, Error> {
        do {
            let myEncodedRequests = try await db.collection("Users").document(userID).getDocument().get("requests")
            var myRequests = [String]()
            if let myEncodedRequests {
                myRequests = try Firestore.Decoder().decode([String].self, from: myEncodedRequests)
            }
            
            if myRequests.contains(uid) {
                // if user liked me -> remove from my requests and from user's pendings
                try await db.collection("Users").document(userID).updateData(["requests" : FieldValue.arrayRemove([uid])])
                try await db.collection("Users").document(userID).updateData(["pending" : FieldValue.arrayRemove([uid])])
                
                // add user to friends for both users
                try await db.collection("Users").document(userID).updateData(["friends" : FieldValue.arrayUnion([uid])])
                try await db.collection("Users").document(uid).updateData(["friends" : FieldValue.arrayUnion([userID])])
            } else {
                // if I liked first -. add to my pendings and user's requests
                try await db.collection("Users").document(userID).updateData(["pending" : FieldValue.arrayUnion([uid])])
                try await db.collection("Users").document(uid).updateData(["requests" : FieldValue.arrayUnion([userID])])
            }
            
            return .success(())

        } catch {
            return .failure(error)
        }
    }
    
    func blockUser(userID: String, uid: String) async -> Result<Void, Error> {
        do {
            // remove from my requests and pendings
            try await db.collection("Users").document(userID).updateData(["requests": FieldValue.arrayRemove([uid])])
            try await db.collection("Users").document(userID).updateData(["pending": FieldValue.arrayRemove([uid])])
            // remove from users requests and pendings
            try await db.collection("Users").document(uid).updateData(["requests": FieldValue.arrayRemove([userID])])
            try await db.collection("Users").document(uid).updateData(["pending": FieldValue.arrayRemove([userID])])
            
            // add to my blocked users
            // get uid user and make a preview model to upload to user.nested collection called blocked

            let uidUser = try await db.collection("Users").document(uid).getDocument(as: UserModel.self)
            let blockedUser = BlockedUserModel(id: uidUser.id,
                                               name: uidUser.name,
                                               image: uidUser.avatar)
            let _ = try await db.collection("Users").document(userID).collection("Blocked").addDocument(data: Firestore.Encoder().encode(blockedUser))
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error> {
        do {
            let encodedLocation = try Firestore.Encoder().encode(location)
            try await db.collection("Users").document(userID).updateData(["location": encodedLocation])
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
