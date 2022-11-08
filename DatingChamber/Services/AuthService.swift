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
    func sendVerificationCode(phone: String) async -> Result<Void, Error>
    func checkVerificationCode(code: String) async -> Result<String, Error>
    func checkExistence(uid: String) async -> Result<Bool, Error>
    func fetchInterests() async -> Result<[String], Error>
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
    func fetchInterests() async -> Result<[String], Error> {
        do {
            let docs = try await db.collection("Interests").getDocuments()
            let interests = docs.documents.map { $0.data()["name"] as! String }
            return .success(interests)
            
        } catch {
            return .failure(error)
        }
    }
    
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
    
//    func uploadImage(image: Data) async -> Result<String, Error> {
//        let dbRef = storageRef.child("profile/\(UUID().uuidString)")
//        do {
//            let ref = try await dbRef.putDataAsync(image).
//            let url = try await ref.storageReference?.downloadURL()
//            return .success("url")
//        } catch {
//            return .failure(error)
//        }
//    }
    
    
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
    
    func sendVerificationCode(phone: String) async -> Result<Void, Error> {
        do {
            let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil)
            UserDefaults.standard.set( verificationID, forKey: "authVerificationID")
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func checkVerificationCode(code: String) async -> Result<String, Error> {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        guard let verificationID else { return .failure(Error.self as! Error) }
        
        do {
            let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            let uid = try await Auth.auth().signIn(with: credential).user.uid
            return .success(uid)
            
        } catch {
            return .failure(error)
        }
    }
}
