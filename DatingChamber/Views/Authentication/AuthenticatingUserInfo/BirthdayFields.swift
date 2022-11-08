//
//  BirthdayFields.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI

struct BirthdayFields: View {
    
    let placeholder: String
    let width: CGFloat
    @Binding var date: String
    
    var body: some View {
        TextField(placeholder, text: $date)
            .foregroundColor(.black)
            .font(.custom("Inter-SemiBold", size: 18))
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .padding(.vertical)
            .frame(width: width)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}
