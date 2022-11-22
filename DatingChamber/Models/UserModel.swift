//
//  UserModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import Foundation
struct UserModel: Identifiable, Codable {
    var id: String
    var name: String
    var birthday: Date
    var avatar: String
    var bio: String
    var images: [String]
    var interests: [String]
}
