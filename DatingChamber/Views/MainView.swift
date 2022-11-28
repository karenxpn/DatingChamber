//
//  MainView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI
import AppTrackingTransparency

struct MainView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationsVM = NotificationsViewModel()
    @StateObject private var tabViewModel = TabViewModel()
    
    var body: some View {
        ZStack( alignment: .bottom) {

            VStack {

                if tabViewModel.currentTab == 0 {
                    CreatePost()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 1 {
                    Swipes()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if tabViewModel.currentTab == 2 {
                    Text("Chats")
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
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
