//
//  PostGridCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct PostGridCell: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @State private var navigate: Bool = false
    let post: PostViewModel
    var body: some View {
        Button {
            navigate.toggle()
        } label: {
            ZStack(alignment: .bottomLeading) {
                ImageHelper(image: post.image, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.4,
                           height: UIScreen.main.bounds.height * 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                TextHelper(text: post.title, color: .white)
                    .lineLimit(1)
                    .padding()
            }
        }.fullScreenCover(isPresented: $navigate, onDismiss: {
            accountVM.posts.removeAll(keepingCapacity: false)
            accountVM.lastPost = nil
            accountVM.getAccount()
            
        }, content: {
            PostDetailiView(post: post)
        })

    }
}

struct PostGridCell_Previews: PreviewProvider {
    static var previews: some View {
        PostGridCell(post: AppPreviewModel.posts[0])
    }
}
