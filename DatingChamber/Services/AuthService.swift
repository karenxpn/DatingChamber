//
//  AuthService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

protocol AuthServiceProtocol {
    func sendVerificationCode(phone: String, completion: @escaping (Error?) -> ())
    func checkVerificationCode(code: String, completion: @escaping ( Error?, String? ) -> () )
    func checkExistence(uid: String) async -> Result<Bool, Error>
    func storeUser(uid: String, user: RegistrationModel) async -> Result<Void, Error>
    func uploadImages(images: [Data], completion: @escaping(Error?, [String]) -> ())
}

class AuthService {
    static var shared: AuthServiceProtocol = AuthService()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    func uploadImages(images: [Data], completion: @escaping (Error?, [String]) -> ()) {
        
        var uploadedImages = [(Int, String)]()
        for (index, image) in images.enumerated() {
            // Create a reference to the file you want to upload
            let dbRef = storageRef.child("profile/\(UUID().uuidString)")
            
            // Upload the file to the path "profile/\(UUID().uuidString)"
            dbRef.putData(image, metadata: nil) { (metadata, error) in
                // You can also access to download URL after upload.
                dbRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        
                        DispatchQueue.main.async {
                            completion(error, [])
                        }
                        return
                    }
                    
                    uploadedImages.append((index, downloadURL.absoluteString))
                    if uploadedImages.count == images.count {
                        DispatchQueue.main.async {
                            completion(nil, uploadedImages.sorted(by: {$0.0 < $1.0}).map{ $0.1})
                        }
                        return
                    }
                }
            }
        }
    }
    
    
    func storeUser(uid: String, user: RegistrationModel) async -> Result<Void, Error> {
        do {
            try await db.collection("Users").document(uid).setData(from: user)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    
    func checkExistence(uid: String) async -> Result<Bool, Error> {
        do {
            let exists = try await db.collection("Users").document(uid).getDocument().exists
            return .success(exists)
        } catch {
            return .failure(error)
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
