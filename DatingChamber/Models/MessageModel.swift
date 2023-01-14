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
import FirebaseService

struct MessageModel: Codable, Firestorable, Equatable {
    var uid: String
        
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        lhs.createdAt < rhs.createdAt
    }
    
    @DocumentID var id: String?
    var createdAt: Timestamp
    var type: MessageType
    var content: String
    var duration: String?
    var sentBy: String
    var seenBy: [String]
    var isEdited: Bool
    var status: MessageStatus
    var repliedTo: RepliedMessageModel?
    var reactions: [String]
    var senderName: String?
    
    init(uid: String? = nil, id: String? = nil, createdAt: Timestamp, type: MessageType, content: String, duration: String? = nil, sentBy: String, seenBy: [String], isEdited: Bool, status: MessageStatus, repliedTo: RepliedMessageModel? = nil, reactions: [String], senderName: String? = nil) {
        self.uid = uid ?? UUID().uuidString
        self.id = id
        self.createdAt = createdAt
        self.type = type
        self.content = content
        self.duration = duration
        self.sentBy = sentBy
        self.seenBy = seenBy
        self.isEdited = isEdited
        self.status = status
        self.repliedTo = repliedTo
        self.reactions = reactions
        self.senderName = senderName
    }
}

struct RepliedMessageModel: Codable {
    var name: String
    var message: String
    var type: MessageType
}

struct MessageViewModel: Identifiable {
    @AppStorage("userID") var userID: String = ""
    
    var message: MessageModel
    init(message: MessageModel) {
        self.message = message
    }
    
    var id: String                              { self.message.id ?? UUID().uuidString }
    var uid: String                             { self.message.uid }
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
    var duration: String                        { self.message.duration ?? "" }
    var senderName: String                      { self.message.senderName ?? "User" }
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
