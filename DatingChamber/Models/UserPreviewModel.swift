//
//  UserPreviewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
struct UserPreviewModel: Identifiable, Codable {
    var id: String
    var name: String
    var image: String
    var online: Bool
    var lastVisit: Date?
    var blocked: Bool
}

struct UserPreviewViewModel: Identifiable {
    var user: UserPreviewModel
    init(user: UserPreviewModel) {
        self.user = user
    }
    
    var id: String              { self.user.id }
    var name: String            { self.user.name }
    var image: String           { self.user.image }
    var online: Bool            { self.user.online }
    var lastVisit: Date? {
        self.user.lastVisit
        // to be modified
    }
    var blocked: Bool           { self.user.blocked }
}
