//
//  MainView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI
import AppTrackingTransparency

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationsVM = NotificationsViewModel()
    @StateObject private var tabViewModel = TabViewModel()
    
    var body: some View {
        ZStack( alignment: .bottom) {

            VStack {

                if tabViewModel.currentTab == 0 {
                    Blog()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 1 {
                    Swipes()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 2 {
                    Chats()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 3 {
                    Account()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }

            CustomTabView()
                .environmentObject(tabViewModel)

        }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                locationManager.initLocation()
                notificationsVM.requestPermission()
                ATTrackingManager.requestTrackingAuthorization { _ in
                }
            }.onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    tabViewModel.updateOnlineStatus(online: true, lastVisit: nil)
                } else {
                    tabViewModel.updateOnlineStatus(online: false, lastVisit: Date().toGlobalTime())
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
