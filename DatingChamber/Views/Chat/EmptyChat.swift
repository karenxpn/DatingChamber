//
//  EmptyChat.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.12.22.
//

import SwiftUI

struct EmptyChat: View {
    let chat: ChatModelViewModel
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            ZStack(alignment: .topLeading) {
                ImageHelper(image: chat.users[0].image, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.3,
                           height: UIScreen.main.bounds.height * 0.2)
                    .clipped()
                    .cornerRadius(10)
                
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 33, height: 33)
                    
                    Image("swipe_heart")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 18)
                        .clipped()
                }.offset(x: -15, y: -15)
            }.rotationEffect(.degrees(-15))
            
            ZStack(alignment: .bottomLeading) {
                ImageHelper(image: chat.users[1].image, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.3,
                           height: UIScreen.main.bounds.height * 0.2)
                    .clipped()
                    .cornerRadius(10)
                
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 33, height: 33)
                    
                    Image("swipe_heart")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 18)
                        .clipped()
                }.offset(x: -15, y: 15)
            }.rotationEffect(.degrees(12))
                .offset(y: -UIScreen.main.bounds.height * 0.09)

            
            VStack(spacing: 8) {
                TextHelper(text: NSLocalizedString("itsMatch", comment: ""), color: AppColors.primary,
                           fontName: "Inter-Bold", fontSize: 24)
                
                TextHelper(text: NSLocalizedString("startConversation", comment: ""),
                           fontName: "Inter-Medium", fontSize: 14)
                .multilineTextAlignment(.center)
            }.offset(y: -UIScreen.main.bounds.height * 0.09)
        }
    }
}

struct EmptyChat_Previews: PreviewProvider {
    static var previews: some View {
        EmptyChat(chat: AppPreviewModel.chats[0])
    }
}
