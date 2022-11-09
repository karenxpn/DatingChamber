//
//  SwipesService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.11.22.
//

import Foundation
import FirebaseFirestore
import GeoFire

protocol SwipesServiceProtocol {
    func fetchSwipes(userID: String,
                     gender: String,
                     minAge: Int,
                     maxAge: Int,
                     online: String,
                     lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([SwipeModel], QueryDocumentSnapshot?), Error>
}

class SwipesService {
    static let shared: SwipesServiceProtocol = SwipesService()
    let db = Firestore.firestore()

    private init() { }
}

extension SwipesService: SwipesServiceProtocol {
    func fetchSwipes(userID: String,
                     gender: String,
                     minAge: Int,
                     maxAge: Int,
                     online: String,
                     lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([SwipeModel], QueryDocumentSnapshot?), Error> {
        
        let dateMinLimit = Calendar.current.date(byAdding: .year, value: -minAge, to: Date()) ?? Date()
        let dateMaxLimit = Calendar.current.date(byAdding: .year, value: -maxAge, to: Date()) ?? Date()
           
        do {
            let ref = db.collection("Users")
            var query: Query = ref
            
            if gender != NSLocalizedString("all", comment: "") { query = ref.whereField("gender", isEqualTo: gender) }
            if online != NSLocalizedString("all", comment: "") { query = query.whereField("online", isEqualTo: true) }
            if maxAge < 51 { query = query.whereField("birthday", isGreaterThanOrEqualTo: dateMaxLimit) }
            if minAge > 18 { query = query.whereField("birthday", isLessThanOrEqualTo: dateMinLimit) }
            
            if lastDocSnapshot == nil   { query = query.limit(to: 10) }
            else                        { query = query.start(afterDocument: lastDocSnapshot!).limit(to: 10) }
            
            let docs = try await query.getDocuments().documents
            let users = try docs.map { try $0.data(as: SwipeModel.self ) }
            
            return .success((users, docs.last))
        } catch {
            return .failure(error)
        }
    }

}
