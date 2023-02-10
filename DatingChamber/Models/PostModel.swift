//
//  PostModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct PostModel: Identifiable, Codable {
    @DocumentID var id: String?
    var createdAt: Date = Date()
    var title: String
    var content: String
    var image: String
    var allowReading: Bool
    var readingVoice: PostReadingVoice?
    var user: PostUserModel?
}

struct PostUserModel: Identifiable, Codable {
    var id: String
    var name: String
    var image: String
}

struct PostViewModel: Identifiable {
    var post: PostModel
    
    init(post: PostModel) {
        self.post = post
    }
    
    var id: String                              { self.post.id ?? "" }
    var title: String                           { self.post.title }
    var content: String                         { self.post.content }
    var image: String                           { self.post.image }
    var allowReading: Bool                      { self.post.allowReading }
    var readingVoice: PostReadingVoice?         { self.post.readingVoice }
    var user: PostUserModel?                    { self.post.user }
    var createdAt: Date                         { self.post.createdAt }
}

enum PostReadingVoice : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case male
    case female
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .male,
        .female,
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .male                  : return "male"
        case .female                : return "female"
        case let .unknown(value)    : return value
        }
    }
}
