//
//  EmptyBlogList.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import SwiftUI

struct EmptyBlogList: View {
    @EnvironmentObject var blogVM: BlogViewModel
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("empty_blog_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(AppColors.primary)
            
            TextHelper(text: NSLocalizedString("emptyBlog", comment: ""), fontName: "Inter-SemiBold", fontSize: 20)
                .multilineTextAlignment(.center)
            
            TextHelper(text: NSLocalizedString("emptyBlogMessage", comment: ""))
                .multilineTextAlignment(.center)
            
            Button {
                blogVM.getPosts()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(AppColors.primary)
                    .font(.title)
                    .padding()
            }

            Spacer()
        }.padding(30)
    }
}

struct EmptyBlogList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyBlogList()
            .environmentObject(BlogViewModel())
    }
}
