//
//  AccountName.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import SwiftUI

struct AccountName: View {
    let name: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(.black, lineWidth: 1)
                
                TextHelper(text: name, fontName: "Inter-SemiBold", fontSize: 14)
                    .padding(.leading, 30)
                
            }.frame(height: 40)
            
            TextHelper(text: NSLocalizedString("fullName", comment: ""), color: .gray, fontName: "Inter-Medium", fontSize: 14)
                .padding(.horizontal, 8)
                .background(.white)
                .padding(.leading, 22)
                .offset(y: -7)
        }
    }
}

struct AccountName_Previews: PreviewProvider {
    static var previews: some View {
        AccountName(name: "Karen")
    }
}
