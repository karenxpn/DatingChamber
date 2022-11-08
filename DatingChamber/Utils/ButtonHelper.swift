//
//  ButtonHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import Foundation
import SwiftUI

struct ButtonHelper: View {
    
    var disabled: Bool
    var height: CGFloat = 56
    let label: String
    let action: (() -> Void)

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                Text( label )
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundColor(.white)
                
                Spacer()
            }.frame(height: height)
            .background(AppColors.primary)
                .opacity(disabled ? 0.5 : 1)
                .cornerRadius(30)
        }.disabled(disabled)
    }
}
