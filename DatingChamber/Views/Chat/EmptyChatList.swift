//
//  EmptyChatList.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import SwiftUI

struct EmptyChatList: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("empty_chat_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(AppColors.primary)
            
            TextHelper(text: NSLocalizedString("emptyChat", comment: ""), fontName: "Inter-SemiBold", fontSize: 20)
                .multilineTextAlignment(.center)
            
            TextHelper(text: NSLocalizedString("emptyChatMessage", comment: ""))
                .multilineTextAlignment(.center)
            
            Button {
                // refresh chats
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(AppColors.primary)
                    .font(.title)
                    .padding()
            }


            Spacer()
        }.padding(30)
    }
}

struct EmptyChatList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyChatList()
    }
}
