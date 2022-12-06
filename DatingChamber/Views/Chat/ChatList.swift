//
//  ChatList.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import SwiftUI

struct ChatList: View {
    let chats: [ChatModelViewModel]
    
    var body: some View {
        List {
            ForEach(chats, id: \.id) { chat in
                ChatListCell(chat: chat)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
        }.listStyle(.plain)
            .padding(.top, 1)
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList(chats: AppPreviewModel.chats)
    }
}
