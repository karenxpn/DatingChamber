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
import OneSignal

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @ObservedObject var notificationsVM = NotificationsViewModel()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId(Credentials.oneSignalAppID)


        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        
        // store device token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()        
        if (firebaseAuth.canHandleNotification(userInfo)){
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
    }
}
