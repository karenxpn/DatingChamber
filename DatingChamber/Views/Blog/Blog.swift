//
//  Blog.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import SwiftUI

struct Blog: View {
    @StateObject var blogVM = BlogViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if blogVM.loading {
                    ProgressView()
                } else {
                    BlogList(posts: blogVM.posts)
                        .environmentObject(blogVM)
                }
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $blogVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(blogVM.alertMessage)
            })
            .navigationTitle(Text(""))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        TextHelper(text: NSLocalizedString("blog", comment: ""),
                                   fontName: "Inter-Black",
                                   fontSize: 24)
                        .kerning(0.56)
                        .accessibilityAddTraits(.isHeader)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            Settings()
                        } label: {
                            Image("icon_settings")
                                .padding(.bottom, 10)
                        }
                    }
                }
            .task {
                blogVM.getPosts()
            }
        }
    }
}

struct Blog_Previews: PreviewProvider {
    static var previews: some View {
        Blog()
    }
}
