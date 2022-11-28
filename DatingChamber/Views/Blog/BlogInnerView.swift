//
//  BlogInnerView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import SwiftUI

struct BlogInnerView: View {
    @State private var navigate: Bool = false
    
    
    var body: some View {
        // scrollview ->
        // VStack
        // friends list with pagination
        // create post button
        // posts list
        ScrollView(showsIndicators: false) {
            VStack {
                
                Button {
                    navigate.toggle()
                } label: {
                    Text("create new post")
                }.navigationDestination(isPresented: $navigate) {
                    CreatePost()
                }

                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            ).padding(30)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }
    }
}

struct BlogInnerView_Previews: PreviewProvider {
    static var previews: some View {
        BlogInnerView()
    }
}
