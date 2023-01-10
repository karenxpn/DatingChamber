//
//  MessageContent.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.12.22.
//

import SwiftUI

struct MessageContent: View {
    @AppStorage("userID") private var userID: String = ""
    @Binding var showReactions: Bool
    let message: MessageViewModel
    
    var body: some View {
        
        ZStack( alignment: .bottomTrailing) {
            
            if message.type == .text {
                TextMessageContent(message: message)
            } else if message.type == .photo {
                PhotoMessageContent(message: message)
            } else if message.type == .video {
                VideoMessageContent(message: message)
            } else if message.type == .audio {
//                AudioMessageContent(message: message, group: group)
            }
            
//            HStack {
//                ForEach(Array(Set(message.reactions.map{ $0.reaction })), id: \.self) { reaction in
//                    Text( "\(reaction) \(message.reactions.filter{ $0.reaction == reaction }.count)" )
//                        .font(.custom("Inter-Regular", size: 10))
//                        .foregroundColor(.black)
//                        .padding(.vertical, 4)
//                        .padding(.horizontal, 10)
//                        .background(.white)
//                        .cornerRadius(20)
//                        .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
//                }
//            }.offset(x: -10,y: 10)
//                .onTapGesture {
//                    showReactions.toggle()
//                }
            
        }
        
    }
}

struct MessageContent_Previews: PreviewProvider {
    static var previews: some View {
        MessageContent(showReactions: .constant(false), message: AppPreviewModel.message)
    }
}
