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
            let usersDocs = try await db.collection(DatabasePaths.users.rawValue).document(userID).collection("Blocked").getDocuments().documents
            let users = try usersDocs.map{ try $0.data(as: BlockedUserModel.self)}
            return .success((users, usersDocs.last))
        } catch {
            return .failure(error)
        }
    }
    
    func updateOnlineState(userID: String, online: Bool, lastVisit: Date?) async -> Result<Void, Error> {
        print("updating")
        return await APIHelper.shared.voidRequest {
            try await db.collection(DatabasePaths.users.rawValue).document(userID).setData(["online": online,
                                                                       "lastVisit": lastVisit], merge: true)
            
            let documents = try await db.collection(DatabasePaths.chats.rawValue).whereField("uids", arrayContains: userID).getDocuments().documents
            
            
            for document in documents {
                var chat = try document.data(as: ChatModel.self)
                                
                if let uid = chat.users.firstIndex(where: { $0.id == userID }) {
                    chat.users[uid].online = online
                    chat.users[uid].lastVisit = lastVisit
                                        
                    let _ = try await db.collection(DatabasePaths.chats.rawValue).document(document.documentID).setData(Firestore.Encoder().encode(chat), merge: true)
                }
            }
        }
    }
    
    func signOut(userID: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(DatabasePaths.users.rawValue).document(userID).setData(["online": false,
                                                                       "lastVisit": Timestamp(date: Date().toGlobalTime())], merge: true)
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
            try await db.collection(DatabasePaths.users.rawValue).document(userID).delete()
        }
    }
    
    func updateAccount(userID: String, updateField: [String: Any]) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(DatabasePaths.users.rawValue).document(userID).setData(updateField, merge: true)
        }
    }
    
    func fetchAccount(userID: String) async -> Result<(UserModel, QueryDocumentSnapshot?), Error> {
        do {
            var user = try await db.collection(DatabasePaths.users.rawValue).document(userID).getDocument().data(as: UserModel.self)
            let posts = try await db.collection(DatabasePaths.blogs.rawValue)
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
            let existence = try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.requests.rawValue).document(uid).getDocument().exists
            let user = try await db.collection(DatabasePaths.users.rawValue).document(uid).getDocument(as: UserModel.self)
            let dislikedUser = FriendModel(id: user.id, name: user.name, image: user.avatar)
            
            if existence {
                // if I dislike user
                // 1. remove from my requests
                // 2. remove from user's pendings
                try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.requests.rawValue).document(uid).delete()
                try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.pending.rawValue).document(userID).delete()

            }
            
            // 3. add to my dislikes
            try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.dislikes.rawValue).document(uid).setData(Firestore.Encoder().encode(dislikedUser))
            
            return .success(())

        } catch {
            return .failure(error)
        }
    }
    
    func likeUser(userID: String, uid: String) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest(action: {
            
            let existence = try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.requests.rawValue).document(uid).getDocument().exists
            let me = try await db.collection(DatabasePaths.users.rawValue).document(userID).getDocument(as: UserModel.self)
            let user = try await db.collection(DatabasePaths.users.rawValue).document(uid).getDocument(as: UserModel.self)
            
            let meAsFriend = FriendModel(id: me.id,
                                         name: me.name,
                                         image: me.avatar)
            
            let userAsFriend = FriendModel(id: user.id,
                                           name: user.name,
                                           image: user.avatar)
            
            if existence {
                // if users exists in my requests
                // 1. remove from my requests
                // 2. remove from user's pendings
                // 3. add to my friends
                // 4. add to user's friends
                // 5. add chat for users
                
                // 1, 2
                try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.requests.rawValue).document(uid).delete()
                try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.pending.rawValue).document(userID).delete()
                
                // 3, 4
                try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.friends.rawValue).document(uid).setData(Firestore.Encoder().encode(userAsFriend))
                try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.friends.rawValue).document(userID).setData(Firestore.Encoder().encode(meAsFriend))
                
                // add chat here
                let chat = ChatModel(users: [UserPreviewModel(id: me.id,
                                                              name: me.name,
                                                              image: me.avatar,
                                                              online: me.online,
                                                              lastVisit: me.lastVisit,
                                                              blocked: false),
                                             UserPreviewModel(id: user.id,
                                                              name: user.name,
                                                              image: user.avatar,
                                                              online: user.online,
                                                              lastVisit: user.lastVisit,
                                                              blocked: false)],
                                     lastMessage: ChatMessagePreview(id: UUID().uuidString,
                                                                     type: .text,
                                                                     content: "Say Hello 🤩",
                                                                     sentBy: "chamber",
                                                                     seenBy: [me.id, user.id],
                                                                     status: .read,
                                                                     createdAt: Timestamp(date: .now.toGlobalTime())),
                                     mutedBy: [], uids: [me.id, user.id])
                
                let _ = try await db.collection(DatabasePaths.chats.rawValue).addDocument(data: Firestore.Encoder().encode(chat))
            } else {
                // if I liked first -. add to my pendings and user's requests
                try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.pending.rawValue).document(uid).setData(Firestore.Encoder().encode(userAsFriend))
                try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.requests.rawValue).document(userID).setData(Firestore.Encoder().encode(meAsFriend))
            }
        })
    }
    
    func blockUser(userID: String, uid: String) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            // remove from my requests and pendings
            try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.requests.rawValue).document(uid).delete()
            try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.pending.rawValue).document(uid).delete()
            try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.friends.rawValue).document(uid).delete()
            
            // remove from users requests and pendings
            try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.requests.rawValue).document(userID).delete()
            try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.pending.rawValue).document(userID).delete()
            try await db.collection(DatabasePaths.users.rawValue).document(uid).collection(DatabasePaths.friends.rawValue).document(userID).delete()
            
            // add to my blocked users
            // get uid user and make a preview model to upload to user.nested collection called blocked

            let uidUser = try await db.collection(DatabasePaths.users.rawValue).document(uid).getDocument(as: UserModel.self)
            let blockedUser = BlockedUserModel(id: uidUser.id,
                                               name: uidUser.name,
                                               image: uidUser.avatar)
            
            let _ = try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.blocked.rawValue).document(uidUser.id).setData(Firestore.Encoder().encode(blockedUser))
        }
    }
    
    func reportUser(userID: String, uid: String, reason: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest(action: {
            let uidUser = try await db.collection(DatabasePaths.users.rawValue).document(uid).getDocument(as: UserModel.self)

            let user = ReportedUserModel(id: uidUser.id,
                                         name: uidUser.name,
                                         image: uidUser.avatar,
                                         reason: reason)
            
            try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.report.rawValue).document(uid).setData(Firestore.Encoder().encode(user))
        })
    }
    
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            let encodedLocation = try Firestore.Encoder().encode(location)
            try await db.collection(DatabasePaths.users.rawValue).document(userID).updateData(["location": encodedLocation])
        }
    }
}
