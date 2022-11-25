//
//  MenuButtonHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.11.22.
//

import SwiftUI

struct MenuButtonsHelper: View {
    let label: String
    let role: ButtonRole
    let action: (() -> Void)

    var body: some View {
        
        Button {
            action()
        } label: {
            
            HStack {
                
                Text( label )
                    .kerning(0.36)
                    .foregroundColor(role == .destructive ? Color.red : Color.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Spacer()
                                    
            }.frame(height: 37)
                .padding(.horizontal)
                .background(.white)
        }
    }
}
