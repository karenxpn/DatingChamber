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
    func fetchPosts(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([PostModel], QueryDocumentSnapshot?), Error>
    func fetchUserPosts(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([PostModel], QueryDocumentSnapshot?), Error>
    func uploadPost(userID: String, image: Data?, imageURL: String?, title: String, content: String, allowReading: Bool, readingVoice: PostReadingVoice?) async -> Result<Void, Error>
    func reportPost(userID: String, postID: String, reason: String) async -> Result<Void, Error>
    func deletePost(postID: String) async -> Result<Void, Error>
}

class BlogService {
    static let shared: BlogServiceProtocol = BlogService()
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    private init() { }
}

extension BlogService: BlogServiceProtocol {
    func reportPost(userID: String, postID: String, reason: String) async -> Result<Void, Error> {
        do {
            let _ = try await db.collection("ReportedPosts").addDocument(data: ["user" : userID,
                                                                        "post" : postID,
                                                                        "reason": reason])
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deletePost(postID: String) async -> Result<Void, Error> {
        do {
            try await db.collection(DatabasePaths.blogs.rawValue).document(postID).delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }    
    
    func fetchUserPosts(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([PostModel], QueryDocumentSnapshot?), Error> {
        do {
            
            var query: Query = db.collection(DatabasePaths.blogs.rawValue).whereField("user.id", isEqualTo: userID).order(by: "createdAt", descending: true)
            if lastDocSnapshot == nil   { query = query.limit(to: 10) }
            else                        { query = query.start(afterDocument: lastDocSnapshot!).limit(to: 10) }
            
            let postDocuments = try await query.getDocuments().documents
            let posts = try postDocuments.map { try $0.data(as: PostModel.self ) }
            
            return .success((posts, postDocuments.last))
            
        } catch {
            return .failure(error)
        }
    }
    
    func uploadPost(userID: String, image: Data?, imageURL: String?, title: String, content: String, allowReading: Bool, readingVoice: PostReadingVoice?) async -> Result<Void, Error> {
        do {
            
            var url: String
            if let imageURL {
                url = imageURL
            } else {
                let dbRef = storageRef.child("blog/\(UUID().uuidString)")
                let _ = try await dbRef.putDataAsync(image!)
                url = try await dbRef.downloadURL().absoluteString
            }
            
            let user = try await db.collection(DatabasePaths.users.rawValue).document(userID).getDocument().data(as: UserModel.self)
            
            let postID = UUID().uuidString
            let post = PostModel(title: title,
                                 content: content,
                                 image: url,
                                 allowReading: allowReading,
                                 readingVoice: readingVoice,
                                 user: PostUserModel(id: user.id,
                                                     name: user.name,
                                                     image: user.avatar))
            
            try await db.collection(DatabasePaths.blogs.rawValue).document(postID).setData(from: post)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchPosts(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([PostModel], QueryDocumentSnapshot?), Error> {
        do {
            // filter data
            let friends = try await db.collection(DatabasePaths.users.rawValue).document(userID).collection(DatabasePaths.friends.rawValue).getDocuments().documents.map{ $0.documentID }
            
            
            var query: Query = db.collection(DatabasePaths.blogs.rawValue).whereField("user.id", in: friends).order(by: "createdAt", descending: true)
            if lastDocSnapshot == nil   { query = query.limit(to: 10) }
            else                        { query = query.start(afterDocument: lastDocSnapshot!).limit(to: 10) }
            
            let postDocuments = try await query.getDocuments().documents
            let posts = try postDocuments.map { try $0.data(as: PostModel.self ) }
            
            return .success((posts, postDocuments.last))
            
        } catch {
            return .failure(error)
        }
    }
}
