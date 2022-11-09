//
//  RegistrationModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import Foundation
import Firebase
import FirebaseFirestore

struct RegistrationModel: Codable, Identifiable {
    var id: String = ""
    var name: String = ""
    var birthday:Date = .now
    var gender: String = ""
    var showGender: Bool = true
    var bio: String = ""
    var images: [String] = []
    var avatar = ""
    var location: LocationModel?
    var online: Bool = true
    var isVerified: Bool = false
    var interests: [String] = []
}

struct LocationModel: Codable {
    var hash: String
    var lat: Double = 0
    var lng: Double = 0
}
