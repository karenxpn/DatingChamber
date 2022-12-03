//
//  PostCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct PostCell: View {
    @EnvironmentObject var blogVM: BlogViewModel
    let post: PostViewModel
    @State private var seePost: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let user = post.user {
                HStack(alignment: .top, spacing: 8) {
                    
                    ImageHelper(image: user.image, contentMode: .fill)
                        .frame(width: 52, height: 52)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        TextHelper(text: user.name, fontName: "Inter-Medium", fontSize: 14)
                        
                        TextHelper(text: post.title, fontName: "Inter-Medium", fontSize: 14)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                TextHelper(text: post.content, fontSize: 12)
                    .lineLimit(3)
                
                Button {
                    seePost.toggle()
                } label: {
                    ImageHelper(image: post.image, contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.8,
                               height: UIScreen.main.bounds.height * 0.25)
                        .clipped()
                        .cornerRadius(10)
                }.buttonStyle(.borderless)
            }
            
        }.padding(28)
            .background(AppColors.light_red)
            .cornerRadius(10)
            .fullScreenCover(isPresented: $seePost, onDismiss: {
                Task {
                    blogVM.posts.removeAll(keepingCapacity: false)
                    blogVM.lastPost = nil
                    blogVM.getPosts()
                }
            }, content: {
                PostDetailiView(post: post)
            })
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: AppPreviewModel.posts[1])
    }
}
