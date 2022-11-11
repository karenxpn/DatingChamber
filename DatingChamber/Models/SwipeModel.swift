//
//  SwipeModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
struct SwipeModel: Codable, Identifiable {
    var id: String
    var avatar: String
    var name: String
    var birthday: Date
    var online: Bool
    var isVerified: Bool
    var interests: [String]
}

struct SwipeUserViewModel: Identifiable {
    var user: SwipeModel
    var myInterests: [String]
    
    init(user: SwipeModel, interests: [String]) {
        self.user = user
        self.myInterests = interests
    }
    
    var id: String          { self.user.id }
    var avatar: String      { self.user.avatar }
    var name: String        { self.user.name }
    var online: Bool        { self.user.online }
    var isVerified: Bool    { self.user.isVerified }
    var age: String         { self.user.birthday.getAgeFromBirthDate() }
    var interests: [InterestModel] {
        let newIntersts = self.user.interests.map { InterestModel(same: myInterests.contains($0) ? true : false, name: $0) }
        return newIntersts.sorted(by: { $0.same && !$1.same })
    }

    
    
    // Card x position
    var x: CGFloat = 0.0
    
    // Card y position
    var y: CGFloat = 0.0
    
    // Card rotation angle
    var degree: Double = 0.0
}

struct InterestModel {
    var same: Bool
    var name: String
}
