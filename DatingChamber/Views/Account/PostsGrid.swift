//
//  PostsGrid.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 29.11.22.
//

import SwiftUI

struct PostsGrid: View {
    @AppStorage("userID") var userID: String = ""
    @EnvironmentObject var accountVM: AccountViewModel
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        LazyVGrid(columns: columns, spacing: 20) {
            
            // creaet new post
            NavigationLink {
                CreatePost()
            } label: {
                Image("add_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
                    .foregroundColor(AppColors.primary)
                    .frame(width: UIScreen.main.bounds.width * 0.4,
                           height: UIScreen.main.bounds.height * 0.2)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(AppColors.light_red, style: StrokeStyle(lineWidth: 1, dash: [10]))
                        
                    )
            }
            
            ForEach(accountVM.posts, id: \.id) { post in
                PostGridCell(post: post)
                    .environmentObject(accountVM)
                    .onAppear {
                        if post.id == accountVM.posts.last?.id && !accountVM.loadingPost {
                            if !userID.isEmpty {
                                accountVM.getPosts()
                            }
                        }
                    }
            }
        }
    }
}

struct PostsGrid_Previews: PreviewProvider {
    static var previews: some View {
        PostsGrid()
            .environmentObject(AccountViewModel())
    }
}
