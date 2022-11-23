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
    
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserService.shared) {
        self.manager = manager
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
}
