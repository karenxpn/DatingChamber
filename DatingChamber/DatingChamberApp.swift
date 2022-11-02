//
//  DatingChamberApp.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI

@main
struct DatingChamberApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("token") private var token: String = ""
    var body: some Scene {
        WindowGroup {
            if token.isEmpty {
                Introduction()
            } else {
                ContentView()
            }
        }
    }
}
