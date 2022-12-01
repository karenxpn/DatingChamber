//
//  PostGridCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct PostGridCell: View {
    @State private var navigate: Bool = false
    let post: PostViewModel
    var body: some View {
        Button {
            
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
        }

    }
}

struct PostGridCell_Previews: PreviewProvider {
    static var previews: some View {
        PostGridCell(post: AppPreviewModel.posts[0])
    }
}