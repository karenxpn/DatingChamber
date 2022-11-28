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
                    BlogInnerView()
                }
            }.task {
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
