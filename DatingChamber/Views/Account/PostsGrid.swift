//
//  PostsGrid.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct PostsGrid: View {
    @EnvironmentObject var accountVM: AccountViewModel
    let posts: [PostViewModel]
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(posts, id: \.id) { post in
                PostGridCell(post: post)
                    .onAppear {
                        if post.id == posts.last?.id && !accountVM.loadingPost {
                            accountVM.getPosts()
                        }
                    }
            }
        }
    }
}

struct PostsGrid_Previews: PreviewProvider {
    static var previews: some View {
        PostsGrid(posts: AppPreviewModel.posts)
            .environmentObject(AccountViewModel())
    }
}
