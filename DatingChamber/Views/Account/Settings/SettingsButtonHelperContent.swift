//
//  SettingsButtonHelperContent.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import SwiftUI

struct SettingsButtonHelperContent: View {
    let label: String
    
    var body: some View {
        HStack {
            Text( label )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 18))
            
            Spacer()
            
            Image("navigate_arrow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 9, height: 18)
            
        }.frame(height: 50)
            .padding(.horizontal)
        .background(.white)
            .cornerRadius(25)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

struct SettingsButtonHelperContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonHelperContent(label: "General")
    }
}
