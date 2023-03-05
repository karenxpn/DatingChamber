//
//  AppDelegate.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Firebase
import UserNotifications
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @ObservedObject var notificationsVM = NotificationsViewModel()

    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        notificationsVM.checkPermissionStatus { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        
        // store device token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        
        let state = application.applicationState
        switch state {
        case .background:
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        default:
            break
        }
        
        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}
