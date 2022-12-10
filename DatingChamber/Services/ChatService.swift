//
//  ChatService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestore

protocol ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ())
    func sendMessage(userID: String, chatID: String, text: String) async -> Result<Void, Error>
    func muteChat(userID: String, chatID: String, mute: Bool) async -> Result<Void, Error>
    func deleteChat(chatID: String) async -> Result<Void, Error>
    
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    let db = Firestore.firestore()
    
    private init() { }
}

extension ChatService: ChatServiceProtocol {
    func muteChat(userID: String, chatID: String, mute: Bool) async -> Result<Void, Error> {
        do {
            try await db.collection("Chats").document(chatID).updateData(["mutedBy" : mute ? FieldValue.arrayUnion([userID]) : FieldValue.arrayRemove([userID])])
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteChat(chatID: String) async -> Result<Void, Error> {
        do {
            try await db.collection("Chats").document(chatID).delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ()){
        // modify this lastMesssage -> lastMessage
        var query: Query = db.collection("Chats").order(by: "lastMessage.createdAt", descending: true)
        if lastChat == nil   { query = query.limit(to: 10) }
        else                 { query = query.start(afterDocument: lastChat!).limit(to: 10) }
        
        query.addSnapshotListener { snapshot, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard snapshot?.documents.last != nil else {
                DispatchQueue.main.async {
                    completion(.success(([], nil)))
                }
                // The collection is empty.
                return
            }
            
            var results = [(ChatModel, DocumentChangeType)]()
            
            snapshot?.documentChanges.forEach({ diff in
                do {
                    let doc = try diff.document.data(as: ChatModel.self)
                    results.append((doc, diff.type))
                } catch {
                    print(error)
                }
                
            })
            
            DispatchQueue.main.async {
                completion(.success((results, snapshot?.documents.last)))
            }
        }
    }
    
    func sendMessage(userID: String, chatID: String, text: String) async -> Result<Void, Error> {
        do {
            let user = try await db.collection("Users").document(userID).getDocument(as: UserModel.self)
            let _ = try await db.collection("Chats").document(chatID).setData(["lastMessage" : ["id": UUID().uuidString,
                                                                                                "content" : text,
                                                                                                "createdAt": Date().toGlobalTime(),
                                                                                                "sentBy": userID,
                                                                                                "seenBy": [userID],
                                                                                                "status": "sent",
                                                                                                "type": "text"]], merge: true)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
