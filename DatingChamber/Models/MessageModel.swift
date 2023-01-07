//
//  MessageModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct MessageModel: Codable, Identifiable {
    @DocumentID var id: String?
    var createdAt: Timestamp
    var type: MessageType
    var content: String
    var sentBy: String
    var seenBy: [String]
    var isEdited: Bool
    var status: MessageStatus
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
    var creationDate: Timestamp                 { self.message.createdAt}
    var createdAt: String                       { self.message.createdAt.dateValue().countTimeBetweenDates() }
    var type: MessageType                       { self.message.type }
    var content: String                         { self.message.content }
    var sentBy: String                          { self.message.sentBy }
    var seen: Bool                              { self.message.seenBy.contains(where: {$0 != sentBy})}
    var isEdited: Bool                          { self.message.isEdited }
    var repliedTo: RepliedMessageModel?         { self.message.repliedTo }
    var reactions: [String]                     { self.message.reactions }
    var status: MessageStatus                   { self.message.status }
}

enum MessageType : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case text
    case photo
    case video
    case audio
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .text,
        .photo,
        .video,
        .audio
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .text                  : return "text"
        case .photo                 : return "photo"
        case .video                 : return "video"
        case .audio                 : return "audio"
        case let .unknown(value)    : return value
        }
    }
}


enum MessageStatus : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case sent
    case read
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .sent,
        .read
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .sent                  : return "sent"
        case .read                  : return "read"
        case let .unknown(value)    : return value
        }
    }
}
