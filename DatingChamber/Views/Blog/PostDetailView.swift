//
//  PostDetailView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.12.22.
//

import SwiftUI
import AVFoundation
import ExpandableText

struct PostDetailView: View {
    
    @AppStorage("userID") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var blogVM = BlogViewModel()
    @StateObject private var speaker = Speaker()
    @State private var showReportReason: Bool = false
    
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
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "post_action_completed"))) { _ in
                presentationMode.wrappedValue.dismiss()
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
                        Menu {
                            
                            if userID == post.user?.id {
                                Button {
                                    blogVM.deletePost(post: post.id)
                                } label: {
                                    Label(NSLocalizedString("delete", comment: ""), systemImage: "trash")
                                }

                                // my post ability to delete it
                            } else {
                                // ability to report post

                                Button {
                                    showReportReason.toggle()
                                } label: {
                                    Label(NSLocalizedString("reportPost", comment: ""), systemImage: "exclamationmark.bubble.fill")
                                }
                            }
                            
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
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $blogVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(blogVM.alertMessage)
            })
            .alert(NSLocalizedString("chooseReasonToReportPost", comment: ""), isPresented: $showReportReason, actions: {
                Button {
                    blogVM.reportPost(post: post.id, reason: NSLocalizedString("fraud", comment: ""))
                } label: {
                    Text( NSLocalizedString("fraud", comment: "") )
                }
                
                Button {
                    blogVM.reportPost(post: post.id, reason: NSLocalizedString("insults", comment: ""))
                } label: {
                    Text( NSLocalizedString("insults", comment: "") )
                }
                
                Button {
                    blogVM.reportPost(post: post.id, reason: NSLocalizedString("sexual", comment: ""))
                } label: {
                    Text( NSLocalizedString("sexual", comment: "") )
                }
                
                Button {
                    blogVM.reportPost(post: post.id, reason: NSLocalizedString("hateSpeach", comment: ""))
                } label: {
                    Text( NSLocalizedString("hateSpeach", comment: "") )
                }
                
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }
            })
        }
        
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: AppPreviewModel.posts[0])
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
