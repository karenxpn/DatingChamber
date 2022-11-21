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
import Combine

class AuthViewModel: AlertViewModel, ObservableObject {
    
    @AppStorage("userID") var userID: String = ""
    @AppStorage("initialuserID") var initialUserID: String = ""
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
    
    @Published var images = [String]()
    
    
    @Published var interests = [String]()
    @Published var selected_interests = [String]()
    
    var manager: AuthServiceProtocol
    
    init(manager: AuthServiceProtocol = AuthService.shared) {
        self.manager = manager
    }
    
    @MainActor
    func sendVerificationCode() {
        loading = true
        Task {
            let result = await manager.sendVerificationCode(phone: "+\(code)\(phoneNumber)")
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success():
                self.navigate = true
            }
            
            if !Task.isCancelled {
                self.loading = false
            }
        }
    }
    
    @MainActor
    func checkVerificationCode() {
        loading = true
        Task {
            let result = await manager.checkVerificationCode(code: OTP)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let uid):
                initialUserID = uid
            }
            
            if !Task.isCancelled {
                self.loading = false
            }
        }
    }
    
    
    func handleAppleServiceSuccess(_ result: FirebaseSignInWithAppleResult) {
        name = (result.token.appleIDCredential.fullName?.givenName ?? "")
        + (result.token.appleIDCredential.fullName?.familyName ?? "")
        initialUserID = result.uid
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
                
                self.name = user.displayName ?? ""
                self.initialUserID = user.uid
                print(user.displayName ?? "Success")
            }
        }
    }
    
    @MainActor
    func checkExistence() {
        loading = true
        Task {
            let result = await manager.checkExistence(uid: initialUserID)
            switch result {
            case .success(let exist):
                self.needInformationFill = !exist
                if exist { self.userID = self.initialUserID }
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                self.loading = false
            }
        }
    }
    
    @MainActor
    func storeUser(model: RegistrationModel) {
        loading = true
        Task {
            let result = await manager.storeUser(uid: initialUserID, user: model)
            
            switch result {
            case .success():
                self.userID = initialUserID
                NotificationCenter.default.post(name: Notification.Name("passedRegistration"), object: nil)
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                self.loading = false
            }
        }
    }
    
    @MainActor
    func getInterests() {
        loading = true
        Task {
            let result = await manager.fetchInterests()
            switch result {
            case .success(let interests):
                self.interests = interests
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                self.loading = false
            }
        }
    }
    
    func uploadImages(images: [Data]) {
        loading = true
        manager.uploadImages(images: images) { error, imgs in
            self.loading = false
            if let error {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            } else {
                self.images.append(contentsOf: imgs)
            }
        }
    }
}
