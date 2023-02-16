//
//  MessagesList.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.12.22.
//

import SwiftUI
import FirebaseService
import FirebaseFirestore

struct MessagesList: View {
    @EnvironmentObject var roomVM: RoomViewModel
    let messages: [MessageViewModel]
        
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { scrollView in
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(messages, id: \.id) { message in
                        MessageCell(message: message)
                            .environmentObject(roomVM)
                            .padding(.bottom, messages[0].id == message.id ? UIScreen.main.bounds.size.height * 0.15 : 0)
                            .padding(.bottom, messages[0].id == message.id &&
                                     ( roomVM.editingMessage != nil || roomVM.replyMessage != nil ) ? UIScreen.main.bounds.height * 0.1 : 0)
                            .rotationEffect(.radians(3.14))
                            .onAppear {
                                if message.id == messages.last?.id && !roomVM.loading {
                                    roomVM.getMessages()
                                }
                            }
                    }
                    
                    if roomVM.loading {
                        ProgressView()
                            .padding()
                            .padding(.top, roomVM.messages.isEmpty ? UIScreen.main.bounds.height * 0.11 : 0)
                    }
                }.padding(.top, 20)
//                .onChange(of: roomVM.typing) { (_) in
//                    roomVM.sendTyping()
//                    if roomVM.typing {
//                        withAnimation {
//                            scrollView.scrollTo(roomVM.lastMessageID, anchor: .bottom)
//                        }
//                    }
//                }
            }
        }.rotationEffect(.radians(3.14))
            .scrollDismissesKeyboard(.immediately)
        .padding(.top, 1)
    }
}

//struct MessagesList_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesList( messages: [AppPreviewModel.message])
//    }
//}
