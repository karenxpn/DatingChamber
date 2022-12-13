//
//  ChatRoom.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.12.22.
//

import SwiftUI

struct ChatRoom: View {
    let chatName: String
    let chatID: String
    @State private var message: String = ""
    
    @StateObject private var roomVM = RoomViewModel()
    
    var body: some View {
        ZStack {
            
            
            VStack {
                Spacer()
                MessageBar()
                    .environmentObject(roomVM)
            }
        }.ignoresSafeArea(.container, edges: .bottom)
            .onAppear {
                NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil)
            }
            .onDisappear {
                NotificationCenter.default.post(name: Notification.Name("showTabBar"), object: nil)
            }.navigationTitle(Text(""))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextHelper(text: chatName,
                               fontName: "Inter-Black",
                               fontSize: 24)
                    .kerning(0.56)
                    .accessibilityAddTraits(.isHeader)
                }
            }
        
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(chatName: "Karen Mirakyan", chatID: "al;dsjkf")
    }
}
