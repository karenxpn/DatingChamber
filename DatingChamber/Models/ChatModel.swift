//
//  ChatModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatModel: Identifiable, Codable {
    @DocumentID var id: String?
    var users: [UserPreviewModel]
    var lastMessage: ChatMessagePreview
    var mutedBy: [String]
    var uids: [String]
}

struct ChatMessagePreview: Identifiable, Codable {
    var id: String
    var type: MessageType
    var content: String
    var sentBy: String
    var seenBy: [String]
    var status: MessageStatus
    var createdAt: Timestamp
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
    
    var messageStatus: MessageStatus        { self.chat.lastMessage.status }
    var messageType: MessageType            { self.chat.lastMessage.type }
    
    var seen: Bool {
        if self.chat.lastMessage.seenBy.contains(where: {$0 != self.chat.lastMessage.sentBy }) { return true }
        return false
    }
    
    var online: Bool {
        if let index = self.chat.users.firstIndex(where: {$0.id != userID }) {
            return self.chat.users[index].online
        }
        return false
    }
    
    var content: String {
        if messageType == .text {
            return self.chat.lastMessage.content
        } else {
            return NSLocalizedString("mediaContent", comment: "")
        }
    }
    
    var date: String                    { self.chat.lastMessage.createdAt.dateValue().countTimeBetweenDates() }
    var users: [UserPreviewViewModel]   { self.chat.users.map(UserPreviewViewModel.init) }
    var lastMessage: ChatMessagePreview { self.chat.lastMessage }
}
