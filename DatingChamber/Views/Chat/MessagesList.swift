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
    let manager: FirestorePaginatedFetchManager<[MessageModel], MessageModel, Timestamp>
        
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { scrollView in
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(messages, id: \.uid) { message in
                        MessageCell(message: message)
                            .environmentObject(roomVM)
                            .padding(.bottom, messages[0].uid == message.uid ? UIScreen.main.bounds.size.height * 0.15 : 0)
                            .padding(.bottom, messages[0].uid == message.uid &&
                                     ( roomVM.editingMessage != nil || roomVM.replyMessage != nil ) ? UIScreen.main.bounds.height * 0.1 : 0)
                            .rotationEffect(.radians(3.14))
                            .onAppear {
                                if let lastMessageUID = messages.last?.uid {
                                    if message.uid == lastMessageUID {
                                        manager.fetch()
                                    }
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
        .padding(.top, 1)
    }
}

//struct MessagesList_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesList( messages: [AppPreviewModel.message])
//    }
//}
