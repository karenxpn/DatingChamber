//
//  LastMessageModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.12.22.
//

import Foundation
import FirebaseFirestore

struct LastMessageModel: Codable, Identifiable {
    var id: String?
    var createdAt: Timestamp
    var type: MessageType
    var content: String
    var sentBy: String
    var seenBy: [String]
    var status: MessageStatus
}
