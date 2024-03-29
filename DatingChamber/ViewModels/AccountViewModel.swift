//
//  AccountViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class AccountViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    @AppStorage("initialuserID") var initialUserID: String = ""
    @Published var user: UserModelViewModel?
    @Published var posts = [PostViewModel]()
    
    @Published var loadingPost: Bool = false
    @Published var lastSnapshot: QueryDocumentSnapshot?
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var interests = [String]()
    @Published var uploadedImages = [String]()
    
    @Published var blockedUsers = [BlockedUserModel]()
    @Published var loadingPage: Bool = false
    
    
    var manager: UserServiceProtocol
    var authManager: AuthServiceProtocol
    var blogManager: BlogServiceProtocol
    
    init(manager: UserServiceProtocol = UserService.shared,
         authManager: AuthServiceProtocol = AuthService.shared,
         blogManager: BlogServiceProtocol = BlogService.shared) {
        self.manager = manager
        self.authManager = authManager
        self.blogManager = blogManager
    }
    
    @MainActor func getAccount() {
        loading = true
        Task {
            let result = await manager.fetchAccount(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                let user = response.0

                self.user = UserModelViewModel(user: user)
                if let posts = user.posts {
                    self.posts = posts.map(PostViewModel.init)
                    self.lastSnapshot = response.1
                }
            }

            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func getPosts() {
        loadingPost = true
        Task {
            let result = await blogManager.fetchUserPosts(userID: userID, lastDocSnapshot: lastSnapshot)
            switch result {
            case .success(let post):
                self.posts.append(contentsOf: post.0.map(PostViewModel.init))
                self.lastSnapshot = post.1
            case .failure( _):
                break
            }

            if !Task.isCancelled {
                loadingPost = false
            }
        }
    }
    
    @MainActor func getInterests() {
        loading = true
        Task {
            let result = await authManager.fetchInterests()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let interests):
                self.interests = interests
            }
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func updateAccount(field: [String: Any]) {
        loading = true
        Task {
            let result = await manager.updateAccount(userID: userID, updateField: field)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name("profile_updated"), object: nil)
            }

            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    func uploadImages(images: [Data]) {
        loading = true
        authManager.uploadImages(images: images) { error, urls in
            self.loading = false
            if let error {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else {
                self.uploadedImages.append(contentsOf: urls)
            }
        }
    }
    
    @MainActor func updateAvatar(image: String) {
        loading = true
        Task {
            let result = await manager.updateAccount(userID: userID, updateField: ["avatar" : image])
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                let image_index = uploadedImages.firstIndex(where: { $0 == image })
                if let image_index {
                    withAnimation {
                        self.uploadedImages.move(from: image_index, to: 0)
                    }
                }
            }

            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func signOut() {
        Task {
            let result = await manager.signOut(userID: userID)
            switch result {
            case .success(()):
                userID = ""
            default:
                break
            }
        }
    }
    
    @MainActor func deleteAccount() {
        Task {
            let result = await manager.deleteAccount()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                let deleteResult = await manager.deleteAccountData(userID: userID)
                switch deleteResult {
                case .failure(let error):
                    self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                case .success(()):
                    self.userID = ""
//                    self.initialUserID = ""
                }
            }
        }
    }
    
    @MainActor func getBlockedUsers(refresh: Refresh? = nil) {
        if refresh == .refresh {
            lastSnapshot = nil
        }
        
        if blockedUsers.isEmpty {
            loading = true
        } else {
            loadingPage = true
        }
        
        Task {
            
            let result = await manager.fetchBlockedUsers(userID: userID, lastUser: lastSnapshot)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                if refresh == .refresh      { self.blockedUsers = response.0 }
                else                        { self.blockedUsers.append(contentsOf: response.0) }
                
                if !response.0.isEmpty {
                    self.lastSnapshot = response.1
                }
            }
                                                                       
            if !Task.isCancelled {
                loading = false
                loadingPage = false
            }
        }
    }
    
}
