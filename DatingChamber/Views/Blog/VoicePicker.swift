//
//  VoicePicker.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import SwiftUI

struct VoicePicker: View {
    @Binding var voice: PostReadingVoice?
    var body: some View {
        
        VStack(alignment: .leading) {
            Button {
                voice = .male
            } label: {
                HStack {
                    ZStack {
                        Image("checkbox")
                        if let voice {
                            if voice == .male {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 12, weight: .semibold))
                            }
                            
                        }
                    }
                    TextHelper(text: NSLocalizedString("maleVoice", comment: ""), fontSize: 12)
                    
                }
            }
            
            
            Button {
                voice = .female
            } label: {
                HStack {
                    ZStack {
                        Image("checkbox")
                        if let voice {
                            if voice == .female {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 12, weight: .semibold))
                                
                            }
                        }
                    }
                    
                    TextHelper(text: NSLocalizedString("femaleVoice", comment: ""), fontSize: 12)
                }
                
            }
        }
    }
}

struct VoicePicker_Previews: PreviewProvider {
    static var previews: some View {
        VoicePicker(voice: .constant(.female))
    }
}
