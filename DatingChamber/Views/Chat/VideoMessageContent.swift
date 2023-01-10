//
//  VideoMessageContent.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.01.23.
//

import SwiftUI
import AVKit

struct VideoMessageContent: View {
    @AppStorage("userID") private var userID: String = ""
    let message: MessageViewModel
    
    var body: some View {
        
        VStack( alignment: message.sentBy == userID && message.repliedTo == nil ? .trailing : .leading) {
            
//            if message.reptyedTo != nil {
//                ReplyedToMessagePreview(senderID: message.sender.id, repliedTo: message.reptyedTo!)
//                    .frame(width: UIScreen.main.bounds.width * 0.5)
//
//            }
            
            if message.content.hasPrefix("https://") {
                let player = AVPlayer(url:  URL(string: message.content)!)
                
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width * 0.5,
                           height: UIScreen.main.bounds.height * 0.4)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                // view here
            } else {
                
                if message.status == .sent && message.sentBy == userID {
                    let asset = AVAsset(url: URL(string: message.content)!)
                    VideoPlayer(player: AVPlayer(playerItem: AVPlayerItem(asset: asset)))
                        .frame(width: UIScreen.main.bounds.width * 0.5,
                               height: UIScreen.main.bounds.height * 0.4)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }.padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(message.sentBy == userID ? AppColors.primary : AppColors.light_blue)
            .cornerRadius(20, corners: message.sentBy == userID ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
    }
}
//
//struct VideoMessageContent_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoMessageContent(message: AppPreviewModels.video_message, group: true)
//    }
//}
