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
    func reportUser(userID: String, uid: String, reason: String) async -> Result<Void, Error>
    
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
        print("updating")
        return await APIHelper.shared.voidRequest {
            try await db.collection("Users").document(userID).setData(["online": online,
                                                                       "lastVisit": lastVisit], merge: true)
            
            let documents = try await db.collection("Chats").whereField("uids", arrayContains: userID).getDocuments().documents
            
            
            for document in documents {
                var chat = try document.data(as: ChatModel.self)
                                
                if let uid = chat.users.firstIndex(where: { $0.id == userID }) {
                    chat.users[uid].online = online
                    chat.users[uid].lastVisit = lastVisit
                                        
                    let _ = try await db.collection("Chats").document(document.documentID).setData(Firestore.Encoder().encode(chat), merge: true)
                }
            }
        }
    }
    
    func signOut(userID: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("Users").document(userID).setData(["online": false,
                                                                       "lastVisit": Date().toGlobalTime()], merge: true)
            try Auth.auth().signOut()
        }
    }
    
    func deleteAccount() async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            try await Auth.auth().currentUser?.delete()
        }
    }
    
    func deleteAccountData(userID: String) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            try await db.collection("Users").document(userID).delete()
        }
    }
    
    func updateAccount(userID: String, updateField: [String: Any]) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("Users").document(userID).setData(updateField, merge: true)
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
        
        return await APIHelper.shared.voidRequest {
            // remove from my requests and pendings
            try await db.collection("Users").document(userID).collection("Requests").document(uid).delete()
            try await db.collection("Users").document(userID).collection("Pending").document(uid).delete()
            
            // remove from users requests and pendings
            try await db.collection("Users").document(uid).collection("Requests").document(userID).delete()
            try await db.collection("Users").document(uid).collection("Pending").document(userID).delete()
            
            // add to my blocked users
            // get uid user and make a preview model to upload to user.nested collection called blocked

            let uidUser = try await db.collection("Users").document(uid).getDocument(as: UserModel.self)
            let blockedUser = BlockedUserModel(id: uidUser.id,
                                               name: uidUser.name,
                                               image: uidUser.avatar)
            
            let _ = try await db.collection("Users").document(userID).collection("Blocked").document(uidUser.id).setData(Firestore.Encoder().encode(blockedUser))
        }
    }
    
    func reportUser(userID: String, uid: String, reason: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest(action: {
            let uidUser = try await db.collection("Users").document(uid).getDocument(as: UserModel.self)

            let user = ReportedUserModel(id: uidUser.id,
                                         name: uidUser.name,
                                         image: uidUser.avatar,
                                         reason: reason)
            
            try await db.collection("Users").document(userID).collection("Report").document(uid).setData(Firestore.Encoder().encode(user))
        })
    }
    
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            let encodedLocation = try Firestore.Encoder().encode(location)
            try await db.collection("Users").document(userID).updateData(["location": encodedLocation])
        }
    }
}
