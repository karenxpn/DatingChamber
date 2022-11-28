//
//  CreatePost.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import SwiftUI

struct CreatePost: View {
    @StateObject private var blogVM = BlogViewModel()
    @State private var showGallery: Bool = false
    @State private var image: Data?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 28) {
                
                HStack(alignment: .bottom) {
                    
                    Button {
                        showGallery.toggle()
                    } label: {
                        if let image {
                            Image(uiImage: UIImage(data: image)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Image("add_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 21, height: 21)
                                .foregroundColor(AppColors.primary)
                                .frame(width: 120, height: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: 100, style: .continuous)
                                        .stroke(AppColors.light_blue, style: StrokeStyle(lineWidth: 1, dash: [10]))
                                    
                                )
                        }
                    }
                    
                    TextHelper(text: NSLocalizedString("addPostCover", comment: ""))
                }
                
                // post title
                VStack(alignment: .leading, spacing: 10) {
                    TextHelper(text: NSLocalizedString("postTitle", comment: ""), color: AppColors.primary, fontName: "Inter-Bold", fontSize: 14)
                    TextField(NSLocalizedString("titlePlaceholder", comment: ""), text: $blogVM.title)
                        .font(.custom("Inter-Regular", size: 16))
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.light_red)
                        )
                }
                
                // post content
                VStack(alignment: .leading, spacing: 10) {
                    TextHelper(text: NSLocalizedString("postContent", comment: ""), color: AppColors.primary, fontName: "Inter-Bold", fontSize: 14)
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $blogVM.content)
                            .foregroundColor(Color.gray)
                            .font(.custom("Inter-Regular", size: 12))
                            .padding(6)
                            .frame(height: 100)
                            .scrollContentBackground(.hidden)
                            .background(AppColors.light_red)
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                        
                        
                        
                        if blogVM.content.isEmpty {
                            TextHelper(text: NSLocalizedString("postContentPlaceholder", comment: ""), fontSize: 12)
                                .padding(10)
                                .padding(.top, 4)
                        }
                    }
                }
                
                // allow voice reading
                CheckboxHelper(toggler: $blogVM.allowReading, message: NSLocalizedString("allowReading", comment: ""))
                
                if blogVM.allowReading {
                    VoicePicker(voice: $blogVM.readingVoice)
                }
                
                Spacer()
                
                ButtonHelper(disabled: !blogVM.postButtonClickable || (blogVM.allowReading && blogVM.readingVoice == nil), label: NSLocalizedString("post", comment: "")) {
                    blogVM.uploadPostImage(image: image)
                }
                
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            ).padding(30)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.scrollDismissesKeyboard(.interactively)
            .sheet(isPresented: $showGallery) {
                Gallery(action: { images in
                    image = images.first
                }, existingImageCount: 0, limit: 1)
            }
    }
}

struct CreatePost_Previews: PreviewProvider {
    static var previews: some View {
        CreatePost()
    }
}
