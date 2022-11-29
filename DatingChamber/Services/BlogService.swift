//
//  BlogService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseFirestore

protocol BlogServiceProtocol {
    func fetchPosts(userID: String) async -> Result<[PostModel], Error>
    func uploadPost(userID: String, image: Data?, imageURL: String?, title: String, content: String, allowReading: Bool, readingVoice: String?) async -> Result<Void, Error>
    
}

class BlogService {
    static let shared: BlogServiceProtocol = BlogService()
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    private init() { }
}

extension BlogService: BlogServiceProtocol {
    func uploadPost(userID: String, image: Data?, imageURL: String?, title: String, content: String, allowReading: Bool, readingVoice: String?) async -> Result<Void, Error> {
        do {
            
            var url: String
            if let imageURL {
                url = imageURL
            } else {
                let dbRef = storageRef.child("blog/\(UUID().uuidString)")
                try await dbRef.putDataAsync(image!)
                url = try await dbRef.downloadURL().absoluteString
            }
            
            let user = try await db.collection("Users").document(userID).getDocument().data(as: UserModel.self)
            
            let post = PostModel(id: UUID().uuidString,
                                 title: title,
                                 content: content,
                                 image: url,
                                 allowReading: allowReading,
                                 readingVoice: readingVoice,
                                 user: PostUserModel(id: user.id,
                                                     name: user.name,
                                                     image: user.avatar))
            
            try await db.collection("Blogs").document(UUID().uuidString).setData(from: post)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchPosts(userID: String) async -> Result<[PostModel], Error> {
        do {
            // filter data
            let encodedFriends = try await db.collection("Users").document(userID).getDocument().get("friends")
            var friends = [String]()
            if let encodedFriends {
                friends = try Firestore.Decoder().decode([String].self, from: encodedFriends)
            }
            friends.append(userID)
            
            let postDocuments = try await db.collection("Blogs").whereField("user.id", in: friends).getDocuments().documents
            let posts = try postDocuments.map { try $0.data(as: PostModel.self ) }
            
            return .success(posts)
            
        } catch {
            return .failure(error)
        }
    }
}
