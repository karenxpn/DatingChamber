//
//  AccountViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AccountViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    @AppStorage("initialuserID") var initialUserID: String = ""
    @Published var user: UserModelViewModel?
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var interests = [String]()
    @Published var uploadedImages = [String]()
    
    var manager: UserServiceProtocol
    var authManager: AuthServiceProtocol
    
    init(manager: UserServiceProtocol = UserService.shared,
         authManager: AuthServiceProtocol = AuthService.shared) {
        self.manager = manager
        self.authManager = authManager
    }
    
    @MainActor func getAccount() {
        loading = true
        Task {
            let result = await manager.fetchAccount(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let user):
                self.user = UserModelViewModel(user: user)
            }
            
            if !Task.isCancelled {
                loading = false
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
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userID = ""
            initialUserID = ""
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @MainActor func deleteAccount() {
        Task {
            let result = await manager.deleteAccount(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                userID = ""
                initialUserID = ""
            }
        }
    }
    
}
