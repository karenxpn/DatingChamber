//
//  TextFieldHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct TextFieldHelper: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .foregroundColor(.black)
            .font(.custom("Inter-Regular", size: 18))
            .padding(.vertical, 15)
            .padding(.horizontal, 12)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

struct TextFieldHelper_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldHelper(placeholder: "Ваше занятие", text: .constant(""))
    }
}
