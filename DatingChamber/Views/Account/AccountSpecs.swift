//
//  AccountSpecs.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct AccountSpecs: View {
    let icon: String
    let label: String
    let value: String
    let destination: AnyView
    var disabled: Bool = false
    var iconColor: Color = .black
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(icon)
                    .foregroundColor(iconColor)
                
                Text( label )
                    .kerning(0.24)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Spacer()
                
                Text( value.isEmpty ? NSLocalizedString( "notSpecified", comment: "") : value )
                    .kerning(0.24)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                if !disabled {
                    Image("navigate_arrow")
                }
                
            }.padding(.vertical, 5)
        }.disabled(disabled)
    }
}

struct AccountSpecs_Previews: PreviewProvider {
    static var previews: some View {
        AccountSpecs(icon: "user_school_icon", label: "Образование", value: "Указать", destination: AnyView(Text( "Destination" )), disabled: false)
    }
}
