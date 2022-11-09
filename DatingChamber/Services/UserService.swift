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
}

class UserService {
    static let shared: UserServiceProtocol = UserService()
    let db = Firestore.firestore()
    private init() { }
}

extension UserService: UserServiceProtocol {
    func updateLocation(userID: String, location: LocationModel) async -> Result<Void, Error> {
        do {
            let encodedLocation = try Firestore.Encoder().encode(location)
            try await db.collection("Users").document(userID).updateData(["location": encodedLocation])
            return .success(())
        } catch {
            print(error)
            return .failure(error)
        }
    }
}
