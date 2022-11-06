//
//  AuthService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

protocol AuthServiceProtocol {
    func sendVerificationCode(phone: String, completion: @escaping (Error?) -> ())
    func checkVerificationCode(code: String, completion: @escaping ( Error?, String? ) -> () )
    func checkExistence(uid: String, completion: @escaping(Error?, Bool) -> ())
    func storeUser(uid: String, user: RegistrationModel, completion: @escaping(Error?) -> ())
}

class AuthService {
    static var shared: AuthServiceProtocol = AuthService()
    let db = Firestore.firestore()
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    
    func storeUser(uid: String, user: RegistrationModel, completion: @escaping (Error?) -> ()) {
        do {
            try db.collection("Users").document(uid).setData(from: user)
            DispatchQueue.main.async {
                completion(nil)
            }
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func checkExistence(uid: String, completion: @escaping (Error?, Bool) -> ()) {
        let docRef = db.collection("Users").document(uid)
        docRef.getDocument { doc, error in
            if let error {
                DispatchQueue.main.async { completion(error, false) }
                return
            }
            
            if let doc, doc.exists {
                print("document exists")
                print(doc)
                DispatchQueue.main.async { completion(nil, true) }
                return

            } else {
                DispatchQueue.main.async { completion(nil, false) }
                print("document does not exist")
                return
            }
        }
    }
    
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
    
    func checkVerificationCode(code: String, completion: @escaping (Error?, String?) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        if verificationID == nil {
            DispatchQueue.main.async {
                completion( nil, nil )
            }
            return
        }
        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: code)
        
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error {
                DispatchQueue.main.async {
                    completion( error, nil )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion( nil, result!.user.uid )
            }
        }
    }
}
