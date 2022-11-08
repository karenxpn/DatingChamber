//
//  SwipeButtonHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

struct SwipeButtonHelper: View {
    let icon: String
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let action: (() -> Void)
    
    var body: some View {
        
        Button(action: action) {
            Image( icon )
                .resizable()
                .foregroundColor(color)
                .frame(width: width, height: height)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(.white)
                .cornerRadius(100)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
        }
    }
}

struct SwipeButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        SwipeButtonHelper(icon: "star", color: .red, width: 18, height: 18, horizontalPadding: 15, verticalPadding: 15, action: {
            print("alskdjf")
        })
    }
}
