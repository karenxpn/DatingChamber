//
//  ChatRoom.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.12.22.
//

import SwiftUI
import FirebaseService
import FirebaseFirestore

struct ChatRoom: View {
    let chat: ChatModelViewModel
    @State private var message: String = ""
    
    @StateObject private var roomVM = RoomViewModel()
    
    var body: some View {
        ZStack {
            
            if roomVM.messages.isEmpty && !roomVM.loading {
                EmptyChat(chat: chat)
            } else {
                MessagesList(messages: roomVM.messages)
                    .environmentObject(roomVM)
            }
            
            VStack {
                Spacer()
                MessageBar()
                    .environmentObject(roomVM)
            }
        }.ignoresSafeArea(.container, edges: .bottom)
            .onAppear {
                NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil)
                roomVM.chatID = chat.id
                roomVM.getMessages()
            }
            .onDisappear {
                NotificationCenter.default.post(name: Notification.Name("showTabBar"), object: nil)
            }.navigationTitle(Text(""))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextHelper(text: chat.name,
                               fontName: "Inter-Black",
                               fontSize: 24)
                    .kerning(0.56)
                    .accessibilityAddTraits(.isHeader)
                }
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $roomVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(roomVM.alertMessage)
            })
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(chat: AppPreviewModel.chats[0])
    }
}
