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

class NotificationsViewModel: ObservableObject {
    
    func requestPermission() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notification: \(accepted)")
        })
    }
    
    func checkPermissionStatus() -> OSNotificationPermission {
        return OneSignal.getDeviceState().notificationPermissionStatus
    }
}
