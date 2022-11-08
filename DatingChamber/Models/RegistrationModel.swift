//
//  RegistrationModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import Foundation
struct RegistrationModel: Codable {
    var name: String = ""
    var birthday: String = ""
    var gender: String = ""
    var showGender: Bool = true
    var bio: String = ""
    var images: [String] = []
    var profileImage = ""
    var location: LocationModel?
}

struct LocationModel: Codable {
    var lat: Double = 0
    var lng: Double = 0
}
