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
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    let db = Firestore.firestore()
    
    private init() { }
}

extension ChatService: ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ()){
        // modify this lastMesssage -> lastMessage
        var query: Query = db.collection("Chats").order(by: "lastMesssage.createdAt", descending: true)
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
}
