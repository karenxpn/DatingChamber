//
//  CustomSegmentPicker.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI


import SwiftUI

struct CustomSegmentPicker: View {
    
    @Binding var selection: String
    let variants: [String]
    let header: String
    
    var body: some View {
        
        VStack( alignment: .leading) {
            TextHelper(text: header, fontName: "Inter-SemiBold", fontSize: 18)
            
            HStack {
                
                ForEach( variants, id: \.self ) { tmp in
                    
                    Button {
                        selection = tmp
                    } label: {
                        Text( tmp )
                            .foregroundColor(tmp == selection ? .white : .black)
                            .font(.custom("Inter-Regular", size: 12))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 25)
                            .background(tmp == selection ? AppColors.primary : .clear)
                            .cornerRadius(30)
                        
                    }
                }
                
            }.padding(4)
            .background(AppColors.light_purple)
                .cornerRadius(30)
        }
    }
}

struct CustomSegmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentPicker(selection: .constant("Мужчина"), variants: ["Man", "Women"], header: "Show Variants")
    }
}
