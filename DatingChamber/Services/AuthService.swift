//
//  AuthService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func sendVerificationCode(phone: String, completion: @escaping (Error?) -> ())
    func checkVerificationCode(code: String, completion: @escaping ( Error? ) -> () )
}

class AuthService {
    static var shared: AuthServiceProtocol = AuthService()
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    func sendVerificationCode(phone: String, completion: @escaping (Error?) -> ()) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
                if let error {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                    return
                }
                
                UserDefaults.standard.set( verificationID!, forKey: "authVerificationID")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
    }
    
    func checkVerificationCode(code: String, completion: @escaping (Error?) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        if verificationID == nil {
            DispatchQueue.main.async {
                completion( nil )
            }
            return
        }
        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: code)
        
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error {
                DispatchQueue.main.async {
                    completion( error )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion( nil )
            }
        }
    }
}
