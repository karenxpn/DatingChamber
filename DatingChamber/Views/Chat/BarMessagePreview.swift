//
//  BarMessagePreview.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 13.01.23.
//

import SwiftUI

struct BarMessagePreview: View {
    @Binding var message: MessageViewModel?

    var body: some View {
        
        HStack( alignment: .top) {
            Capsule()
                .fill(AppColors.primary)
                .frame(width: 3, height: 35)
            
            if let message = message {
                VStack( alignment: .leading) {
                    Text(message.senderName)
                        .foregroundColor(AppColors.primary)
                        .font(.custom("Inter-SemiBold", size: 12))
                    
                    
                    if message.type == .text {
                        Text(message.content)
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                            .kerning(0.24)
                            .lineLimit(1)
                    } else if message.type == .photo {
                        ImageHelper(image: message.content, contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                    } else if message.type == .video {
                        Text(NSLocalizedString("videoContent", comment: ""))
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                            .kerning(0.24)

                    } else if message.type == .audio {
                        Text(NSLocalizedString("audioContent", comment: ""))
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                            .kerning(0.24)
                    }
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    message = nil
                }
            } label: {
                Image("close_reply")
            }
        }.padding(.horizontal, 20)
            .padding(.top, 15)
            .background(.white)
            .cornerRadius(35, corners: [.topLeft, .topRight])
            .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
    }
}
