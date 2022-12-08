//
//  ChatListCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import SwiftUI

struct ChatListCell: View {
    let chat: ChatModelViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ImageHelper(image: chat.image , contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                TextHelper(text: chat.name, fontName: "Inter-SemiBold" )
                    .lineLimit(1)
                
                    TextHelper(text: chat.content, fontSize: 14)
                        .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                TextHelper(text: "\(chat.date)", color: .gray, fontSize: 11)
                    .lineLimit(1)
                
                if chat.messageStatus == "pending" {
                    ProgressView()
                        .scaleEffect(0.5)
                } else {
                    Image(chat.seen ? "read_icon" : "sent_icon")
                        .foregroundColor(chat.seen ? AppColors.primary : .black)
                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
            .background(
                chat.seen ? AppColors.light_red : .clear
            )
    }
}

struct ChatListCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatListCell(chat: AppPreviewModel.chats[0])
    }
}
