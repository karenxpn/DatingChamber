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
                     lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<(([SwipeModel], [String]), QueryDocumentSnapshot?), Error>
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
                     lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<(([SwipeModel], [String]), QueryDocumentSnapshot?), Error> {
        
        let dateMinLimit = Calendar.current.date(byAdding: .year, value: -minAge, to: Date()) ?? Date()
        let dateMaxLimit = Calendar.current.date(byAdding: .year, value: -maxAge, to: Date()) ?? Date()
           
        do {
            let ref = db.collection("Users")
            var query: Query = ref
            
            let encodedUserInterests = try await ref.document(userID).getDocument().get("interests")
            let interests = try Firestore.Decoder().decode([String].self, from: encodedUserInterests)
            
            if gender != NSLocalizedString("all", comment: "") { query = ref.whereField("gender", isEqualTo: gender) }
            if online != NSLocalizedString("all", comment: "") { query = query.whereField("online", isEqualTo: true) }
            if maxAge < 51 { query = query.whereField("birthday", isGreaterThanOrEqualTo: dateMaxLimit) }
            if minAge > 18 { query = query.whereField("birthday", isLessThanOrEqualTo: dateMinLimit) }
            query = query.whereField("interests", arrayContainsAny: interests)
            
            if lastDocSnapshot == nil   { query = query.limit(to: 10) }
            else                        { query = query.start(afterDocument: lastDocSnapshot!).limit(to: 10) }
            
            let docs = try await query.getDocuments().documents
            let users = try docs.map { try $0.data(as: SwipeModel.self ) }
            
            return .success(((users, interests), docs.last))
        } catch {
            return .failure(error)
        }
    }

}


// can be copied for location queries if future
// interests field should be added to filter and add indexes
//do {
//    let ref = db.collection("Users")
//
//    // get my location
//    let encodedlocation = try await ref.document(userID).getDocument().get("location")
//    let location = try Firestore.Decoder().decode(LocationModel.self, from: encodedlocation)
//
//    // create center and radus of the request
//    let center = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
//    let radiusInM: Double = 50 * 1000
//
//    let queryBounds = GFUtils.queryBounds(forLocation: center,
//                                          withRadius: radiusInM)
//
//    let queries = queryBounds.map { bound -> Query in
//
//        let ref = db.collection("Users")
//        var query: Query = ref
//
//        if gender != NSLocalizedString("all", comment: "") { query = query.whereField("gender", isEqualTo: gender) }
//        if online != NSLocalizedString("all", comment: "") { query = query.whereField("online", isEqualTo: true) }
//        if maxAge < 51 { query = query.whereField("birthday", isGreaterThanOrEqualTo: dateMaxLimit) }
//        if minAge > 18 { query = query.whereField("birthday", isLessThanOrEqualTo: dateMinLimit) }
//
//        if lastDocSnapshot == nil   { query = query.limit(to: 2) }
//        else                        { query = query.start(afterDocument: lastDocSnapshot!).limit(to: 2) }
//
//        return query
//            .order(by: "birthday")
//            .order(by: "location.hash")
//            .start(at: [bound.startValue])
//            .end(at: [bound.endValue])
//    }
//
//    var users = [SwipeModel]()
//    var lastDoc: QueryDocumentSnapshot?
//
//    for query in queries {
//        let docs = try await query.getDocuments().documents
//        users.append(contentsOf: try docs.map { try $0.data(as: SwipeModel.self ) } )
//        print(users)
//        lastDoc = docs.last
//    }
//
//    return .success((users, lastDoc))
//
//} catch {
//    return .failure(error)
//}
