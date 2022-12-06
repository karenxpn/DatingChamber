//
//  ChatModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatModel: Identifiable, Codable {
    @DocumentID var id: String?
    var users: [UserPreviewModel]
    var lastMesssage: ChatMessagePreview
}

struct ChatMessagePreview: Identifiable, Codable {
    var id: String
    var content: String
}


struct ChatModelViewModel: Identifiable {
    var chat: ChatModel
    init(chat: ChatModel) {
        self.chat = chat
    }
    
    var id: String                      { self.chat.id ?? UUID().uuidString }
    // to be modified
    var image: String                   { self.chat.users[0].image }
    var name: String                    { self.chat.users[0].name }
    var content: String                 { self.chat.lastMesssage.content }
    //
    var users: [UserPreviewViewModel]   { self.chat.users.map(UserPreviewViewModel.init) }
    var lastMessage: ChatMessagePreview { self.chat.lastMesssage }
}
