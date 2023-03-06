//
//  NotificationsViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import Foundation
import SwiftUI
import UserNotifications
import OneSignal
import FirebaseFirestore

class NotificationsViewModel: ObservableObject {
    @AppStorage("userID") var userID: String = ""
    
    func requestPermission() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            if accepted {
                let player = OneSignal.getDeviceState().userId
                Firestore.firestore().collection(DatabasePaths.players.rawValue).document(self.userID)
                    .setData(["player_id": player])
            }
        })
    }
    
    func checkPermissionStatus() -> OSNotificationPermission {
        return OneSignal.getDeviceState().notificationPermissionStatus
    }
}
