//
//  SendNotificationModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.03.23.
//

import Foundation
struct NotificationMessageModel: Codable {
    var title: String
    var subtitle: NotificationSubtitle
    var contents: NotificationContents
    var include_player_ids: [String]
}

struct NotificationSubtitle: Codable {
    var en: String
}

struct NotificationContents: Codable {
    var en: String
}
