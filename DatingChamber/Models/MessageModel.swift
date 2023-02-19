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

struct MessageModel: Codable {
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
    var reactions: [ReactionModel]
    var senderName: String?
}

struct RepliedMessageModel: Codable {
    var name: String
    var message: String
    var type: MessageType
}

struct ReactionModel: Codable, Equatable {
    var userId: String
    var reaction: String
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
    var seenBy: [String]                        { self.message.seenBy }
    var isEdited: Bool                          { self.message.isEdited }
    var repliedTo: RepliedMessageModel?         { self.message.repliedTo }
    var reactions: [String]                     { self.message.reactions.map{ $0.reaction} }
    var status: MessageStatus                   { self.message.status }
    var duration: String                        { self.message.duration ?? "" }
    var senderName: String                      { self.message.senderName ?? "User" }
    var reactionModels: [ReactionModel]         { self.message.reactions }
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
    case pending
    case deleted
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .sent,
        .read,
        .pending,
        .deleted
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .sent                  : return "sent"
        case .read                  : return "read"
        case .pending               : return "pending"
        case .deleted               : return "deleted"
        case let .unknown(value)    : return value
        }
    }
}
