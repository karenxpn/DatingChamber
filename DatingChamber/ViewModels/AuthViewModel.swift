//
//  AuthViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseService
import Firebase
import GoogleSignIn

class AuthViewModel: AlertViewModel, ObservableObject {
    
    @AppStorage("userID") var userID: String = ""
    @AppStorage("name") var name: String = ""
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var country: String = "US"
    @Published var code: String = "1"
    @Published var phoneNumber: String = ""
    @Published var OTP: String = ""
    
    @Published var navigate: Bool = false
    @Published var agreement: Bool = false
    
    @Published var needInformationFill: Bool = false
    
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
        manager.checkVerificationCode(code: OTP) { error, uid in
            self.loading = false
            if let error {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else {
                self.userID = uid!
            }
        }
    }
    
    
    func handleAppleServiceSuccess(_ result: FirebaseSignInWithAppleResult) {
        name = (result.token.appleIDCredential.fullName?.givenName ?? "")
        + (result.token.appleIDCredential.fullName?.familyName ?? "")
        userID = result.uid
    }
    
    func handleAppleServiceError(_ error: Error) {
        makeAlert(with: error, message: &alertMessage, alert: &showAlert)
    }
    
    func googleSignin(viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        loading = true
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [self] user, error in
            if let error {
                self.loading = false
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                self.loading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // Firebase auth
            Auth.auth().signIn(with: credential) { result, error in
                self.loading = false
                
                if let error {
                    self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                    return
                }
                
                // Displaying user name
                guard let user = result?.user else {
                    return
                }
                
                self.userID = user.uid
                self.name = user.displayName ?? ""
                
                print(user.displayName ?? "Success")
            }
        }
    }
    
    func checkExistence() {
        loading = true
        manager.checkExistence(uid: userID) { error, exist in
            self.loading = false
            if let error {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else if exist {
                // go on
                self.needInformationFill = false
                
            } else if !exist {
                self.needInformationFill = true
                // show fill the form view
            }
        }
    }
    
    func storeUser(model: RegistrationModel) {
        loading = true
        manager.storeUser(uid: userID, user: model) { error in
            self.loading = false
            if let error {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else {
                NotificationCenter.default.post(name: Notification.Name("passedRegistration"), object: nil)
            }
        }
    }
}
