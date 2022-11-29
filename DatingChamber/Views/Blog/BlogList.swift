//
//  BlogList.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct BlogList: View {
    @EnvironmentObject var blogVM: BlogViewModel
    let posts: [PostViewModel]
    @State private var navigate: Bool = false
    
    var body: some View {
        List {
            ForEach(posts, id: \.id) { post in
                PostCell(post: post)
            }
            
            Spacer()
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.listStyle(.plain)
            .padding(.top, 1)
            .refreshable {
                blogVM.getPosts()
            }
    }
}

struct BlogList_Previews: PreviewProvider {
    static var previews: some View {
        BlogList(posts: AppPreviewModel.posts)
    }
}