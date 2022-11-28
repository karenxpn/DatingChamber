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
    func fetchPosts() async -> Result<[PostModel], Error>
    func uploadPostImage(image: Data) async -> Result<String, Error>
    func uploadPost(userID: String, title: String, content: String, image: String, allowReading: Bool, readingVoice: String?) async -> Result<Void, Error>
    
}

class BlogService {
    static let shared: BlogServiceProtocol = BlogService()
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    private init() { }
}

extension BlogService: BlogServiceProtocol {
    func uploadPost(userID: String, title: String, content: String, image: String, allowReading: Bool, readingVoice: String?) async -> Result<Void, Error> {
        do {
            let user = try await db.collection("Users").document(userID).getDocument().data(as: UserModel.self)
            try await db.collection("Users").document(userID).collection("Blog").addDocument(data: [
                "id" : UUID().uuidString,
                "title": title,
                "content": content,
                "image": image,
                "allowReading": allowReading,
                "readingVoice": readingVoice,
                "user": [
                    "id": user.id,
                    "name": user.name,
                    "avatar": user.avatar
                ]
            ])
            
            return .success(())
        } catch {
            return .failure(error)
        }
        // get me
        // assign to post user and upload
    }
    
    func fetchPosts() async -> Result<[PostModel], Error> {
        return .success([])
    }
    
    func uploadPostImage(image: Data) async -> Result<String, Error> {
        do {
            let dbRef = storageRef.child("blog/\(UUID().uuidString)")
            let res = try await dbRef.putDataAsync(image)
            let url = try await dbRef.downloadURL().absoluteString
            
            return .success(url)
        } catch {
            return .failure(error)
        }
    }
}
