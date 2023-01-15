//
//  RecordingPreview.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 13.12.22.
//

import SwiftUI

import FirebaseFirestore
import FirebaseService

struct RecordingPreview: View {
    @EnvironmentObject var roomVM: RoomViewModel
    @StateObject var audioVM: AudioPlayViewModel
    let url: URL
    let duration: Int
    let manager: FirestorePaginatedFetchManager<[MessageModel], MessageModel, Timestamp>

    
    init(url: URL, duration: Int, manager: FirestorePaginatedFetchManager<[MessageModel], MessageModel, Timestamp>
) {
        self.url = url
        self.duration = duration
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: url, sampels_count: Int(UIScreen.main.bounds.width * 0.5 / 4)))
        self.manager = manager
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 70) / 2 // between 0.1 and 35
        
        return CGFloat(level * (40/35))
    }
    
    
    var body: some View {
        HStack( spacing: 10 ) {
            
            Button {
                audioVM.pauseAudio()
                audioVM.removeAudio()
            } label: {
                Image("trash_icon")
                    .foregroundColor(.black)
            }
            
            HStack {
                
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
                
                HStack(spacing: 2) {
                    
                    ForEach(audioVM.soundSamples, id: \.self) { model in
                        BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                    }
                }
                
                Text("\(duration / 60):\(duration % 60 < 10 ? "0\(duration % 60)" : "\(duration % 60)")")
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            Button {
                sendAudio()
            } label: {
                Image("icon_send_message")
                    .padding(.vertical, 20)
            }
            
        }.padding(.horizontal, 20)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 96)
            .background(.white)
            .cornerRadius(35, corners: [.topLeft, .topRight])
            .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
            .onAppear {
                audioVM.visualizeAudio()
            }
    }
    
    func sendAudio() {
        do {
            let data = try Data(contentsOf: audioVM.url)
            roomVM.media = data

            roomVM.sendMessage(messageType: .audio,
                               duration: "\(duration / 60):\(duration % 60 < 10 ? "0\(duration % 60)" : "\(duration % 60)")", firestoreManager: manager)
        } catch {
            print(error)
        }
    }
}

//struct RecordingPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingPreview()
//    }
//}

struct BarView: View {
    let value: CGFloat
    var color: Color = Color.gray
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .cornerRadius(10)
                .frame(width: 2, height: value)
        }
    }
}
