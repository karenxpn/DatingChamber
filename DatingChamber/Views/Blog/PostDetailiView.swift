//
//  PostDetailiView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.12.22.
//

import SwiftUI
import AVFoundation
import ExpandableText

struct PostDetailiView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var reading: Bool = false
    let post: PostViewModel
    let utterance: AVSpeechUtterance
    let synthesizer: AVSpeechSynthesizer
    
    init(post: PostViewModel) {
        self.post = post
        self.utterance = AVSpeechUtterance(string: post.content)
        self.utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.utterance.rate = 0.5
        
        self.synthesizer = AVSpeechSynthesizer()
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer()
                    
                    ImageHelper(image: post.image, contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.85)
                        .clipped()
                        .cornerRadius(10)
                    
                    Spacer()
                    
                }
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            ExpandableText(text: post.content)
                            
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundColor(.white)
                                .lineLimit(3)
                                .expandButton(TextSet(text: NSLocalizedString("seeMore", comment: ""), font: .body, color: .white))
                                .collapseButton(TextSet(text: NSLocalizedString("seeLess", comment: ""), font: .body, color: .white))
                                .expandAnimation(.easeOut)
                            
                            
                            if post.allowReading {
                                Button {
                                    
                                    if reading {
                                        synthesizer.pauseSpeaking(at: .word)
                                    } else {
                                        if synthesizer.isPaused {
                                            synthesizer.continueSpeaking()
                                        } else {
                                            synthesizer.speak(utterance)
                                        }
                                    }
                                    
                                    reading.toggle()
                                    
                                } label: {
                                    Image(reading ? "voice_off" : "voice_on")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(30)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }.padding(.top, 1)
                }
                
            }
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 20) {
                        if let user = post.user {
                            ImageHelper(image: user.image, contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                            
                            TextHelper(text: user.name, color: .white, fontName: "Inter-Medium", fontSize: 14)
                                .kerning(0.56)
                            
                        }
                    }.accessibilityAddTraits(.isHeader)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Image("dots")
                        }
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("close_post")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 17, height: 17)
                        }

                    }
                }
            }
        }
        
    }
}

struct PostDetailiView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailiView(post: AppPreviewModel.posts[0])
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
