//
//  AccountViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import Foundation
import SwiftUI

class AccountViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    @Published var user: UserModelViewModel?
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var interests = [String]()
    
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
    
    @MainActor func updateInterests(interests: [String]) {
        loading = true
        Task {
            let result = await manager.updateInterests(userID: userID, interests: interests)
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
}
