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
    @Environment(\.scenePhase) private var phase
    @StateObject var authState = AuthState()
    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
//        newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, .font: UIFont( name: "Inter-Regular", size: 28)!]
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
        }.onChange(of: phase) { newScene in
            switch newScene {
            case .active:
                UIApplication.shared.applicationIconBadgeNumber = 0
            default:
                break
            }
        }
    }
}
