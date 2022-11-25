//
//  NotificationsViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationsViewModel: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    override init() {
        super.init()
    }
    
    func requestPermission() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current()
            .requestAuthorization(options: options) { (granted, error) in
            
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func checkPermissionStatus(completion: @escaping(UNAuthorizationStatus) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            DispatchQueue.main.async {
                completion(permission.authorizationStatus)
            }
        }
    }
}
