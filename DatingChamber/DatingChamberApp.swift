//
//  DatingChamberApp.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI
import FirebaseService

@main
struct DatingChamberApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authState = AuthState()
    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
        UINavigationBar.appearance().standardAppearance = newAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            switch authState.value {
            case .undefined:
                ProgressView()
            case .authenticated:
                ContentView()
            case .notAuthenticated:
                Introduction()
            }
        }
    }
}
