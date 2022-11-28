//
//  BlogViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation
import SwiftUI
import Combine

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
    
    @Published var posts = [PostViewModel]()
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
    
    @MainActor func getPosts() {
        loading = true
        Task {
            let result = await manager.fetchPosts()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let posts):
                self.posts = posts.map(PostViewModel.init)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func uploadPostImage(image: Data?) {
        uploading = true

        Task {
            
            if let image  {
                let result = await manager.uploadPostImage(image: image)
                switch result {
                case .failure(let error):
                    self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                case .success(let imageURL):
                    self.uploadPost(imageURL: imageURL)
                }
            } else {
                self.uploadPost(imageURL: Credentials.default_story_image)
            }
            
            if !Task.isCancelled {
                uploading = false
            }
        }
    }
        
    @MainActor func uploadPost(imageURL: String) {
        uploading = true

        Task {

            let result = await manager.uploadPost(userID: userID, title: title, content: content, image: imageURL, allowReading: allowReading, readingVoice: readingVoice)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                break
            }
            
            if !Task.isCancelled {
                uploading = false
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
