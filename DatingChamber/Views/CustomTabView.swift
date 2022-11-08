//
//  CustomTabView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

import SwiftUI


struct CustomTabView: View {
    @EnvironmentObject var tabViewModel: TabViewModel
    @State private var tab: Bool = true
    let icons = ["home_icon", "swipes_icon", "chat_icon", "account_icon"]
    
    var body: some View {
        Group {
            if tab {
                ZStack {
                    
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(35, corners: [.topLeft, .topRight])
                        .shadow(radius: 2)
                    
                    HStack {
                        
                        ForEach ( 0..<icons.count, id: \.self ) { id in
                            
                            Spacer()
                            Button {
                                withAnimation {
                                    tabViewModel.currentTab = id
                                }
                            } label: {
                                ZStack( alignment: .topTrailing ) {
                                    Image(icons[id])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(id == tabViewModel.currentTab ? AppColors.primary : .black)
                                        .frame(width: 28, height: 28)
                                    
                                    
                                    if id == 2 && tabViewModel.hasUnreadMessage {
                                        ZStack {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 10, height: 10)
                                            
                                            Circle()
                                                .fill(.red)
                                                .frame(width: 5, height: 5)
                                        }
                                    }
                                    
                                }.padding(10)
                            }
                            
                            Spacer()
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(10)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.1)
            } else {
                EmptyView()
            }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "hideTabBar"))) { _ in
            tab = false
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "showTabBar"))) { _ in
            withAnimation {
                tab = true
            }
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
            .environmentObject(TabViewModel())
    }
}
