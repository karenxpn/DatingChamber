//
//  BlogViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation

class BlogViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var posts = [PostViewModel]()
    var manager: BlogServiceProtocol
    
    init(manager: BlogServiceProtocol = BlogService.shared) {
        self.manager = manager
    }
    
    func getPosts() {
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
}
