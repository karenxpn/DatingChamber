//
//  ReportedUserModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 26.02.23.
//

import Foundation
struct ReportedUserModel: Identifiable, Codable {
    var id: String
    var name: String
    var image: String
    var reason: String
}
