//
//  PostCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct PostCell: View {
    let post: PostViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = post.user {
                HStack(alignment: .top) {
                    
                    ImageHelper(image: user.image, contentMode: .fill)
                        .frame(width: 52, height: 52)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        TextHelper(text: user.name, fontName: "Inter-Medium", fontSize: 14)
                        
                        HStack {
                            if post.allowReading {
                                TextHelper(text: NSLocalizedString("readingAllowed", comment: ""), fontSize: 12)
                                Button {
                                    
                                } label: {
                                    Image(systemName: "speaker.wave.2")
                                        .foregroundColor(.black)
                                        .padding(.horizontal)
                                }.buttonStyle(.borderless)
                                
                            }
                        }
                    }
                }
            }
            
            TextHelper(text: post.title, fontName: "Inter-Medium", fontSize: 14)
            TextHelper(text: post.content)
                .lineLimit(5)
            
            ImageHelper(image: post.image, contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.8,
                       height: UIScreen.main.bounds.height * 0.3)
                .clipped()
                .cornerRadius(10)
            
        }.padding(28)
            .background(AppColors.light_red)
            .cornerRadius(10)
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: AppPreviewModel.posts[1])
    }
}
