//
//  AuthProgress.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI

import SwiftUI

struct AuthProgress: View {
    
    let page: Int
        
    var body: some View {
        GeometryReader { proxy in
            HStack( spacing: 0) {
                Spacer()
                ForEach(0...6, id: \.self) { index in
                    if index == 0 || index == 6 {
                        Rectangle()
                            .fill(index <= page ? AppColors.primary : AppColors.accent)
                            .cornerRadius(20, corners: index == 0 ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight])
                    } else {
                        Rectangle()
                            .fill(index <= page ? AppColors.primary : AppColors.accent)
                    }
                }
                
                Spacer()
            }.frame( height: 6)
                .padding(.horizontal)
        }
    }
}

struct AuthProgress_Previews: PreviewProvider {
    static var previews: some View {
        AuthProgress(page: 6)
    }
}
