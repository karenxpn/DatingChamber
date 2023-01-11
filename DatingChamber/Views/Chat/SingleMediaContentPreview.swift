//
//  SingleMediaContentPreview.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 11.01.23.
//

import SwiftUI
import AVFoundation

struct SingleMediaContentPreview: View {
    @Environment(\.presentationMode) var presentationMode
    let url: URL
    let mediaType: MessageType
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("close_popup")
                        .padding()
                }

            }
            
            Spacer()
            
            if mediaType == .video {
                AVPlayerControllerRepresented(player: AVPlayer(url: url))
            } else if mediaType == .photo {
                ImageHelper(image: url.absoluteString, contentMode: .fit)
            }
            
            Spacer()
        }

    }
}

struct SingleMediaContentPreview_Previews: PreviewProvider {
    static var previews: some View {
        SingleMediaContentPreview(url: URL(string: Credentials.default_story_image)!, mediaType: .photo)
    }
}
