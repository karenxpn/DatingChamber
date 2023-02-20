//
//  AudioMessageContent.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 13.01.23.
//

import SwiftUI
import AVFoundation
import AVKit

struct AudioMessageContent: View {
    @StateObject private var audioVM: AudioPlayViewModel
    @AppStorage("userID") private var userID: String = ""
    let message: MessageViewModel
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 70) / 2 // between 0.1 and 35
        
        return CGFloat(level * (40/35))
    }
    
    init(message: MessageViewModel) {
        self.message = message
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: URL(string: message.content)!, sampels_count: Int(UIScreen.main.bounds.width * 0.6 / 4)))
    }
    
    var body: some View {
        VStack( alignment: message.sentBy == userID && message.repliedTo == nil ? .trailing : .leading ) {

            if message.repliedTo != nil {
                ReplyedToMessagePreview(senderID: message.sentBy, repliedTo: message.repliedTo!, contentType: message.type)
                    .frame(width: UIScreen.main.bounds.width * 0.6)
            }
            
            LazyHStack(alignment: .center, spacing: 10) {
                
                Button {
                    if audioVM.isPlaying {
                        audioVM.pauseAudio()
                    } else {
                        audioVM.playAudio()
                    }
                } label: {
                    Image(!(audioVM.isPlaying) ? "play_icon" : "pause_icon" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                
                HStack(alignment: .center, spacing: 2) {
                    if audioVM.soundSamples.isEmpty {
                        ProgressView()
                    } else {
                        ForEach(audioVM.soundSamples, id: \.self) { model in
                            BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                        }
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.6)
                
                
                Text(message.duration)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
            }
        }.padding(.vertical, 8)
    }
}
