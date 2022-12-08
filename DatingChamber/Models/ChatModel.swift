//
//  ChatModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct ChatModel: Identifiable, Codable {
    @DocumentID var id: String?
    var users: [UserPreviewModel]
    var lastMesssage: ChatMessagePreview
    var mutedBy: [String]
}

struct ChatMessagePreview: Identifiable, Codable {
    var id: String
    var type: String
    var content: String
    var sentBy: String
    var seenBy: [String]
    var status: String
}


struct ChatModelViewModel: Identifiable {
    @AppStorage("userID") var userID: String = ""

    var chat: ChatModel
    init(chat: ChatModel) {
        self.chat = chat
    }
    
    var id: String                      { self.chat.id ?? UUID().uuidString }
    var image: String {
        if let user = self.chat.users.first(where: {$0.id != userID }) { return user.image }
        return Credentials.default_story_image
    }
    
    var name: String {
        if let user = self.chat.users.first(where: {$0.id != userID }) { return user.name }
        return ""
    }
    
    var muted: Bool {
        if self.chat.mutedBy.contains(userID) { return true }
        return false
    }
    
    var messageStatus: String   { self.chat.lastMesssage.status }
    var messageType: String     { self.chat.lastMesssage.type }
    
    var seen: Bool {
        if self.chat.lastMesssage.seenBy.contains(userID) &&
            self.chat.lastMesssage.sentBy != userID { return true }
        return false
    }
    
    // to be modified
    // content -> detect content type
    var content: String                 { self.chat.lastMesssage.content }
    var date: String                    { "1min ago" }
    //
    var users: [UserPreviewViewModel]   { self.chat.users.map(UserPreviewViewModel.init) }
    var lastMessage: ChatMessagePreview { self.chat.lastMesssage }
}
