//
//  TextMessageContent.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.12.22.
//


import SwiftUI
//import LinkPreview

struct TextMessageContent: View {
    @AppStorage("userID") private var userID: String = ""
    let message: MessageViewModel
    
    var body: some View {
        
        if message.content.isSingleEmoji {
            Text(message.content)
                .font(.system(size: 102))
        }
//        else if message.content.hasPrefix("https://") {
//            LinkPreview(url: URL(string: message.content))
//                .backgroundColor(message.sender.id == userID ? AppColors.accentColor : AppColors.addProfileImageBG)
//                .primaryFontColor(message.sender.id == userID ? .white : .black)
//                .secondaryFontColor(.white.opacity(0.6))
//                .titleLineLimit(3)
//                .frame(width: UIScreen.main.bounds.width * 0.5, alignment: message.sender.id == userID ? .trailing : .leading)
//        }
        else {
            VStack( alignment: message.sentBy == userID && message.repliedTo == nil ? .trailing : .leading) {
                
//                if message.reptyedTo != nil {
//                    ReplyedToMessagePreview(senderID: message.sender.id, repliedTo: message.reptyedTo!)
//                }
                
                Text(message.content)
                    .foregroundColor(message.sentBy == userID ? .white : .black)
                    .font(.custom("Inter-Regular", size: 12))
                    .kerning(0.24)
                
            }.padding(.vertical, 12)
                .padding(.horizontal, 15)
                .background(message.sentBy == userID ? AppColors.primary : AppColors.light_blue)
                .cornerRadius(20, corners: message.sentBy == userID ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
        }
    }
}

struct TextMessageContent_Previews: PreviewProvider {
    static var previews: some View {
        TextMessageContent(message: AppPreviewModel.message)
    }
}
