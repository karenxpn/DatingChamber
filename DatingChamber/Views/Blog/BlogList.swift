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
                    .onAppear {
                        if post.id == blogVM.posts.last?.id && !blogVM.loadingPage {
                            print("faced \(post.id)")
                            blogVM.getPosts()
                        }
                    }
            }
            
            if blogVM.loadingPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            
            Spacer()
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.listStyle(.plain)
            .padding(.top, 1)
            .refreshable {
                blogVM.posts.removeAll(keepingCapacity: false)
                blogVM.lastPost = nil
                blogVM.getPosts()
            }
    }
}

struct BlogList_Previews: PreviewProvider {
    static var previews: some View {
        BlogList(posts: AppPreviewModel.posts)
    }
}
