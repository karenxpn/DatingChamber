//
//  Enums.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
enum Refresh {
    case refresh
}

enum CardAction {
    case dislike, like, star, report
}

enum BirthdayForm: Hashable {
    case day
    case month
    case year
}

enum ReactionAction {
    case remove, react
}


enum DatabasePaths : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case users
    case chats
    case pending
    case requests
    case dislikes
    case friends
    case blocked
    case report
    case blogs
    case messages
    case interests
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .users,
        .chats,
        .pending,
        .requests,
        .dislikes,
        .friends,
        .blocked,
        .report,
        .blogs,
        .messages,
        .interests
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .users                     : return "Users"
        case .chats                     : return "Chats"
        case .pending                   : return "Pending"
        case .requests                  : return "Requests"
        case .dislikes                  : return "Dislikes"
        case .friends                   : return "Friends"
        case .blocked                   : return "Blocked"
        case .report                    : return "Report"
        case .blogs                     : return "Blogs"
        case .messages                  : return "messages"
        case .interests                 : return "Interests"
        case let .unknown(value)    : return value
        }
    }
}
