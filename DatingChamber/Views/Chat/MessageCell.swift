//
//  MessagesCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.12.22.
//

import SwiftUI
import Popovers

struct MessageCell: View {

    @AppStorage("userID") private var userID: String = ""
    @EnvironmentObject var roomVM: RoomViewModel
    @State private var offset: CGFloat = .zero
    @State private var present: Bool = false
    @State private var navigate: Bool = false
    
    @State private var showPopOver: Bool = false
    let reactions = ["👍", "👎", "❤️", "😂", "🤣", "😡", "😭"]
    
    let message: MessageViewModel
    
    var body: some View {
        HStack( alignment: .bottom, spacing: 10) {
            
            if message.sentBy == userID {
                Spacer()
            }
            
            
            if message.sentBy == userID {
                
                Image(message.seen ? "read_icon" : "sent_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 7)
                
                Text("\(message.createdAt)\(message.isEdited ? "(\(NSLocalizedString("edited", comment: "")))" : "")")
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 8))
            }
            
            
            MessageContent(message: message)
                .scaleEffect(showPopOver ? 0.8 : 1)
                .blur(radius: showPopOver ? 0.7 : 0)
                .animation(.easeInOut, value: showPopOver)
                .onTapGesture(perform: {
                    if message.type == .video || message.type == .photo {
                        present.toggle()
                    }
                }).fullScreenCover(isPresented: $present, content: {
                    SingleMediaContentPreview(url: URL(string: message.content)!, mediaType: message.type)
                }).onLongPressGesture(minimumDuration: 0.7, perform: {
                    showPopOver = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                })
                .popover(
                    present: $showPopOver,
                    attributes: {
                        $0.position = .absolute(
                            originAnchor: .top,
                            popoverAnchor: message.sentBy == userID ? .bottomRight : .bottomLeft
                        )
                    }
                ) {
                    HStack {
                        
                        ForEach(reactions, id: \.self) { reaction in
                            Button {
                                roomVM.sendReaction(message: message, reaction: reaction)
                                showPopOver = false
                            } label: {
                                Text(reaction)
                                    .font(.system(size: 28))
                            }
                        }
                        
                    }.padding(.horizontal, 24)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            
                .popover(
                    present: $showPopOver,
                    attributes: {
                        $0.position = .absolute(
                            originAnchor: .bottom,
                            popoverAnchor: .top
                        )
                    }
                ) {
                    VStack(alignment: .leading, spacing: 0) {
                        MenuButtonsHelper(label: NSLocalizedString("reply", comment: ""), role: .cancel) {
                            roomVM.replyMessage = message
                            showPopOver = false
                        }
                        Divider()
                        
                        if message.type == .text {
                            MenuButtonsHelper(label: NSLocalizedString("copy", comment: ""), role: .cancel) {
                                UIPasteboard.general.string = message.content
                                showPopOver = false
                            }
                            Divider()
                            if message.sentBy == userID {
                                MenuButtonsHelper(label: NSLocalizedString("edit", comment: ""), role: .cancel) {
                                    roomVM.editingMessage = message
                                    roomVM.message = message.content
                                    showPopOver = false
                                }
                                Divider()
                            }
                        }
                        
                        if message.sentBy == userID {
                            MenuButtonsHelper(label: NSLocalizedString("delete", comment: ""), role: .destructive) {
                                roomVM.deleteMessage(messageID: message.id)
                                showPopOver = false
                            }
                        }
                        
                    }.frame(width: 200)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            
            if message.sentBy != userID {
                Text("\(message.createdAt)\(message.isEdited ? "(\(NSLocalizedString("edited", comment: "")))" : "")")
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 8))
            }
            
            if message.sentBy != userID {
                Spacer()
            }
        }.padding(.horizontal, 20)
            .padding(message.sentBy == userID ? .leading : .trailing, UIScreen.main.bounds.width * 0.05)
            .padding(.vertical, 8)
            .padding(.bottom, (roomVM.lastMessageID == message.id && showPopOver) ? UIScreen.main.bounds.height * 0.08 : 0)
            .offset(x: offset)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    let cur = value.translation.width
                    if message.sentBy == userID {
                        if cur < 0 && cur >= -100 {
                            offset = cur
                        }
                    } else {
                        if cur > 0 && cur <= 100 {
                            offset = cur
                        }
                    }
                    
                }).onEnded({ value in
                    let cur = value.translation.width
                    
                    if message.sentBy == userID && cur <= -100 {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        roomVM.replyMessage = message
                    } else if message.sentBy != userID && cur >= 100 {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        roomVM.replyMessage = message
                    }
                    offset = 0
                    
                })
            )
            .onAppear {
                if message.status == .sent && message.sentBy != userID {
//                    roomVM.sendReadMessage(messageID: message.id)
                }
            }
    }
}

struct MessagesCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(message: AppPreviewModel.message)
                    .environmentObject(RoomViewModel())
        
    }
}
