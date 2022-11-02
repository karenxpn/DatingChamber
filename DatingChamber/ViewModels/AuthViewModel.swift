//
//  AuthViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AuthViewModel: AlertViewModel, ObservableObject {
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var country: String = "US"
    @Published var code: String = "1"
    @Published var phoneNumber: String = ""
    @Published var OTP: String = ""
    
    @Published var navigate: Bool = false
    @Published var agreement: Bool = false
    
    @Published var shouldLogIn: Bool = false
    
    var manager: AuthServiceProtocol
    
    init(manager: AuthServiceProtocol = AuthService.shared) {
        self.manager = manager
    }
    
    func sendVerificationCode() {
        loading = true
        manager.sendVerificationCode(phone: "+\(code)\(phoneNumber)") { error in
            self.loading = false
            if let error {
                print(error.localizedDescription)
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else {
                self.navigate = true
            }
        }
    }
    
    func checkVerificationCode() {
        loading = true
        manager.checkVerificationCode(code: OTP) { error in
            self.loading = false
            if let error {
                print(error.localizedDescription)
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else {
                print("signed in")
            }
        }
    }
}
