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

    @StateObject private var speaker = Speaker()
    let post: PostViewModel
    
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
                                    
                                    if speaker.isSpeaking {
                                        speaker.synthesizer.pauseSpeaking(at: .word)
                                    } else {
                                        if speaker.synthesizer.isPaused {
                                            speaker.synthesizer.continueSpeaking()
                                        } else {
                                            speaker.speak()
                                        }
                                    }
                                } label: {
                                    Image(speaker.isSpeaking ? "voice_off" : "voice_on")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(30)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }.padding(.top, 1)
                }
                
            }.onAppear {
                speaker.initializeSpeaker(content: post.content)
            }.onDisappear {
                speaker.synthesizer.stopSpeaking(at: .immediate)
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
