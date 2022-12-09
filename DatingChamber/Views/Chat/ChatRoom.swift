//
//  ChatRoom.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.12.22.
//

import SwiftUI

struct ChatRoom: View {
    let chatID: String
    @State private var message: String = ""
    
    @StateObject private var roomVM = RoomViewModel()
    
    var body: some View {
        TextField("place text here", text: $message)
        ButtonHelper(disabled: false, label: "Send") {
            roomVM.sendMessage(text: message, chat: chatID)
            // send message
        }
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoom(chatID: "al;dsjkf")
    }
}
