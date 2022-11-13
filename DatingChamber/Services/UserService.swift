//
//  UserService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.11.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserServiceProtocol {
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error>
    func likeUser(userID: String, uid: String) async -> Result<Void, Error>
    func dislikeUser(userID: String, uid: String) async -> Result<Void, Error>
//    func blockUser(userID: String, uid: String) async -> Result<Void, Error>
}

class UserService {
    static let shared: UserServiceProtocol = UserService()
    let db = Firestore.firestore()
    private init() { }
}

extension UserService: UserServiceProtocol {
    func dislikeUser(userID: String, uid: String) async -> Result<Void, Error> {
        do {
            let myEncodedRequests = try await db.collection("Users").document(userID).getDocument().get("requests")
            var myRequests = [String]()
            if let myEncodedRequests {
                myRequests = try Firestore.Decoder().decode([String].self, from: myEncodedRequests)
            }
            
            if myRequests.contains(uid) {
                // if I dislike user
                // remove from requests and add to dislikes
                // remove user's pending request as I dislik
                try await db.collection("Users").document(userID).updateData(["requests" : FieldValue.arrayRemove([uid])])
                try await db.collection("Users").document(userID).updateData(["dislikes" : FieldValue.arrayUnion([uid])])
                try await db.collection("Users").document(uid).updateData(["pending" : FieldValue.arrayRemove([userID])])

            } else {
                try await db.collection("Users").document(userID).updateData(["dislikes" : FieldValue.arrayUnion([uid])])
            }
            
            return .success(())

        } catch {
            return .failure(error)
        }
    }
    
    func likeUser(userID: String, uid: String) async -> Result<Void, Error> {
        do {
            let myEncodedRequests = try await db.collection("Users").document(userID).getDocument().get("requests")
            var myRequests = [String]()
            if let myEncodedRequests {
                myRequests = try Firestore.Decoder().decode([String].self, from: myEncodedRequests)
            }
            
            if myRequests.contains(uid) {
                // if user liked me -> remove from my requests and from user's pendings
                try await db.collection("Users").document(userID).updateData(["requests" : FieldValue.arrayRemove([uid])])
                try await db.collection("Users").document(userID).updateData(["pending" : FieldValue.arrayRemove([uid])])
                
                // add user to friends for both users
                try await db.collection("Users").document(userID).updateData(["friends" : FieldValue.arrayUnion([uid])])
                try await db.collection("Users").document(uid).updateData(["friends" : FieldValue.arrayUnion([userID])])
            } else {
                // if I liked first -. add to my pendings and user's requests
                try await db.collection("Users").document(userID).updateData(["pending" : FieldValue.arrayUnion([uid])])
                try await db.collection("Users").document(uid).updateData(["requests" : FieldValue.arrayUnion([userID])])
            }
            
            return .success(())

        } catch {
            return .failure(error)
        }
    }
    
//    func blockUser(userID: String, uid: String) async -> Result<Void, Error> {
//
//    }
    
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error> {
        do {
            let encodedLocation = try Firestore.Encoder().encode(location)
            try await db.collection("Users").document(userID).updateData(["location": encodedLocation])
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
