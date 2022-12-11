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
    @State private var showDelete: Bool = false
    
    
    var body: some View {
        List {
            ForEach(chats, id: \.id) { chat in
                ChatListCell(chat: chat)
                    .onAppear {
                        if chat.id == chatVM.chats.last?.id && !chatVM.loadingPage {
                            chatVM.getChats()
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .swipeActions {
                        Button {
                            showDelete.toggle()
                        } label: {
                            Image("message_delete_icon")
                        }.tint(.red)
                        
                        Button {
                            chatVM.muteChat(chatID: chat.id, mute: !chat.muted)
                        } label: {
                            if chat.muted {
                                Image("message_notification_icon")
                            } else {
                                Image("message_mute_icon")
                            }
                        }.tint(AppColors.light_blue)
                    }.alert(NSLocalizedString("sureToDeleteChat", comment: ""), isPresented: $showDelete, actions: {
                        Button(NSLocalizedString("delete", comment: ""), role: .destructive) {
                            chatVM.deleteChat(chatID: chat.id)
                        }
                        Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }
                        
                    }, message: {
                        TextHelper(text: NSLocalizedString("deleteChatMessage", comment: ""))
                    })
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
            .refreshable {
                chatVM.getChats(refresh: .refresh)
            }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList(chats: AppPreviewModel.chats)
            .environmentObject(ChatViewModel())
    }
}
