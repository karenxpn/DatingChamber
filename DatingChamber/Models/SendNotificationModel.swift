//
//  SendNotificationModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.03.23.
//

import Foundation
struct NotificationMessageModel: Codable {
    var message: SendNotificationModel
}

struct SendNotificationModel: Codable {
    var token: String
    var notification: NotificationModel
}

struct NotificationModel: Codable {
    var body: String
    var title: String
}
