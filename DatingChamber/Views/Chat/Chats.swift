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
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $chatVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(chatVM.alertMessage)
            }).navigationTitle(Text(""))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        TextHelper(text: NSLocalizedString("chats", comment: ""),
                                   fontName: "Inter-Black",
                                   fontSize: 24)
                        .kerning(0.56)
                        .accessibilityAddTraits(.isHeader)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            Settings()
                        } label: {
                            Image("icon_settings")
                                .padding(.bottom, 10)
                        }
                    }
                }
        }
    }
}

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        Chats()
    }
}
