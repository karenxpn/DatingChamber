//
//  UserViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.11.22.
//

import Foundation
import SwiftUI

class UserViewModel: AlertViewModel, ObservableObject {
    
    @AppStorage("userID") var userID: String = ""
    @Published var reportReason: String = ""
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var manager: UserServiceProtocol
    
    init(manager: UserServiceProtocol = UserService.shared) {
        self.manager = manager
    }
    
    @MainActor func likeUser(uid: String) {
        Task {
            let result = await manager.likeUser(userID: userID, uid: uid)
            switch result {
            case .failure(let error):
                print(error)
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                break
            }
        }
    }
    
    @MainActor func dislikeUser(uid: String) {
        Task {
            let result = await manager.dislikeUser(userID: userID, uid: uid)
        }
    }
    
    @MainActor func blockUser(uid: String) {
        Task {
            let result = await manager.blockUser(userID: userID, uid: uid)
        }
    }
}
