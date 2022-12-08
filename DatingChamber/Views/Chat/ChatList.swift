//
//  ChatList.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import SwiftUI

struct ChatList: View {
    @EnvironmentObject var chatVM: ChatViewModel
    let chats: [ChatModelViewModel]
    
    var body: some View {
        List {
            ForEach(chats, id: \.id) { chat in
                ChatListCell(chat: chat)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            
            if chatVM.loadingPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            
            Spacer()
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                .listRowSeparator(.hidden)

        }.listStyle(.plain)
            .padding(.top, 1)
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList(chats: AppPreviewModel.chats)
            .environmentObject(ChatViewModel())
    }
}
