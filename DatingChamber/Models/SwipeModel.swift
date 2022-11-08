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
    var birthday: String
    var online: Bool
    var isVerified: Bool
    var interests: [String]
}

struct SwipeUserViewModel: Identifiable {
    var user: SwipeModel
    
    init(user: SwipeModel) {
        self.user = user
    }
    
    var id: String          { self.user.id }
    var avatar: String      { self.user.avatar }
    var name: String        { self.user.name }
    var online: Bool        { self.user.online }
    var isVerified: Bool    { self.user.isVerified }
    var interests: [String] { self.user.interests }
    var age: String         { self.user.birthday.getAgeFromDOF() }
    
    
    // Card x position
    var x: CGFloat = 0.0
    
    // Card y position
    var y: CGFloat = 0.0
    
    // Card rotation angle
    var degree: Double = 0.0
}

