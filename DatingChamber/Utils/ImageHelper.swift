//
//  ImageHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageHelper: View {
    let image: String
    let contentMode: ContentMode
    
    var body: some View {
        WebImage(url: URL(string: image))
            .placeholder(content: {
                ProgressView()
            })
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
