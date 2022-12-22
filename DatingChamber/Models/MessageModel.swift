//
//  MessageModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct MessageModel: Codable, Identifiable {
    @DocumentID var id: String?
    var createdAt: Date
    var type: String
    var content: String
    var sentBy: String
    var seenBy: [String]
    var isEdited: Bool
    var repliedTo: RepliedMessageModel?
    var reactions: [String]
}

struct RepliedMessageModel: Codable {
    var message: String
    var type: String
    var name: String
}

struct MessageViewModel: Identifiable {
    @AppStorage("userID") var userID: String = ""

    var message: MessageModel
    init(message: MessageModel) {
        self.message = message
    }
    
    var id: String                              { self.message.id ?? UUID().uuidString }
    var createdAt: String                       { self.message.createdAt.countTimeBetweenDates() }
    var type: String                            { self.message.type }
    var content: String                         { self.message.content }
    var sentBy: String                          { self.message.sentBy }
    var seen: Bool                              { self.message.seenBy.contains(where: {$0 != sentBy})}
    var isEdited: Bool                          { self.message.isEdited }
    var repliedTo: RepliedMessageModel?         { self.message.repliedTo }
    var reactions: [String]                     { self.message.reactions }
}
