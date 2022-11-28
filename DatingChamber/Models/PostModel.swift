//
//  PostModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation
struct PostModel: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var image: String
    var allowReading: Bool
    var readingVoice: String?
    
}

struct PostViewModel: Identifiable {
    var post: PostModel
    init(post: PostModel) {
        self.post = post
    }
    
    var id: String                  { self.post.id }
    var title: String               { self.post.title }
    var content: String             { self.post.content }
    var image: String               { self.post.image }
    var allowReading: Bool          { self.post.allowReading }
    var readingVoice: String?       { self.post.readingVoice }
}
