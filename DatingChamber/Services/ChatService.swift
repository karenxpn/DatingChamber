//
//  ChatService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestore

protocol ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?) async -> Result<[ChatModel], Error>
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    let db = Firestore.firestore()

    private init() { }
}

extension ChatService: ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?) async -> Result<[ChatModel], Error> {
        do {
            // modify this
            let docs = try await db.collection("Chats").getDocuments().documents
            let chats = try docs.map { try $0.data(as: ChatModel.self ) }
            return .success(chats)
        } catch {
            return .failure(error)
        }
    }
}
