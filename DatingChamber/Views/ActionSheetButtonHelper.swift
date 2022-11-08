//
//  ActionSheetButtonHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation

import SwiftUI

struct ActionSheetButtonHelper: View {
    let icon: String
    let label: String
    let role: ButtonRole
    let action: (() -> Void)

    var body: some View {
        
        Button {
            action()
        } label: {
            
            HStack {
                
                Image(icon)
                    .foregroundColor(role == .destructive ? Color.red : Color.black)

                TextHelper(text: label, color: role == .destructive ? Color.red : Color.black, fontName: "Inter-Medium", fontSize: 18)
                    .kerning(0.36)
                
                Spacer()
                    
            }.frame(height: 55)
                .padding(.horizontal)
                .background(.white)
            
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ActionSheetButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetButtonHelper(icon: "", label: "Пожаловаться", role: .destructive, action: {
            
        })
    }
}
