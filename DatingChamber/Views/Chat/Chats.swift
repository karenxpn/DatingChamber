//
//  Chats.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import SwiftUI

struct Chats: View {
    @StateObject private var chatVM = ChatViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if chatVM.loading {
                    ProgressView()
                } else if chatVM.chats.isEmpty {
                    EmptyChatList()
                } else {
                    ChatList()
                }
            }.task {
                chatVM.getChats()
            }
        }
    }
}

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        Chats()
    }
}
