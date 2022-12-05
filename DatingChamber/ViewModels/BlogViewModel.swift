//
//  BlogViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class BlogViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var allowReading: Bool = false
    @Published var readingVoice: String?
    @Published var postButtonClickable: Bool = false
    
    @Published var uploading: Bool = false
    
    @Published var loadingPage: Bool = false
    @Published var posts = [PostViewModel]()
    @Published var lastPost: QueryDocumentSnapshot?
    
    private var cancellableSet: Set<AnyCancellable> = []
    var manager: BlogServiceProtocol
    
    init(manager: BlogServiceProtocol = BlogService.shared) {
        self.manager = manager
        super.init()
        
        isPostButtonClickable
            .receive(on: RunLoop.main)
            .assign(to: \.postButtonClickable, on: self)
            .store(in: &cancellableSet)
    }
    
    @MainActor func getPosts(refresh: Refresh? = nil) {
        if refresh == .refresh {
            lastPost = nil
        }
        
        if posts.isEmpty {
            loading = true
        } else if refresh != .refresh {
            loadingPage = true
        }
        
        Task {
            let result = await manager.fetchPosts(userID: userID, lastDocSnapshot: lastPost)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let posts):
                if refresh == .refresh  { self.posts = posts.0.map(PostViewModel.init) }
                else                    { self.posts.append(contentsOf: posts.0.map(PostViewModel.init)) }
                
                if !posts.0.isEmpty {
                    self.lastPost = posts.1
                }
            }
            
            if !Task.isCancelled {
                loading = false
                loadingPage = false
            }
        }
    }
    
    @MainActor func uploadPost(image: Data?) {
        
        uploading = true
        Task {
            let result = await manager.uploadPost(userID: userID,
                                                  image: image,
                                                  imageURL: image == nil ? Credentials.default_story_image : nil,
                                                  title: title, content: content, allowReading: allowReading, readingVoice: readingVoice)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name("post_uploaded"), object: nil)
            }
            
            if !Task.isCancelled {
                uploading = false
            }
        }
    }
    
    @MainActor func reportPost( post: String, reason: String) {
        Task {
            let result = await manager.reportPost(userID: userID, postID: post, reason: reason)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name("post_action_completed"), object: nil)

            }
        }
    }
    
    @MainActor func deletePost(post: String) {
        Task {
            let result = await manager.deletePost(postID: post)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name("post_action_completed"), object: nil)
            }
        }
    }
    
    
    // publisher validation
    private var isTitleValid: AnyPublisher<Bool, Never> {
        $title
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { !$0.isEmpty && $0.count <= 100 }
            .eraseToAnyPublisher()
    }
    
    private var isContentValid: AnyPublisher<Bool, Never> {
        $content
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map{ !$0.isEmpty && $0.count <= 2000 }
            .eraseToAnyPublisher()
    }
    
    private var isPostButtonClickable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isTitleValid, isContentValid)
            .map { title, content in
                return title && content
            }.eraseToAnyPublisher()
    }
}
