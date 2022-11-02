//
//  TermsOfUse.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI

struct TermsOfUse: View {
    @Binding var agreement: Bool
    @Binding var animate: Bool
    var body: some View {
        HStack {
            
            Button {
                agreement.toggle()
            } label: {
                ZStack {
                    if agreement {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(AppColors.accentColor)
                            .frame(width: 16, height: 16, alignment: .center)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(.black, lineWidth: 1)
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    
                    if agreement {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10, alignment: .center)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Link(NSLocalizedString("termsOfUse", comment: ""), destination: URL(string: Credentials.terms_of_use)!)
                .foregroundColor(.blue)
                .font(.custom("Inter-Regular", size: 12))
            
            Text( "*Required" )
                .foregroundColor(.red)
                .font(.custom("Inter-Regular", size: 10))
            
        }.scaleEffect(animate ? 1.3 : 1)
    }
}

struct TermsOfUse_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUse(agreement: .constant(true), animate: .constant(false))
    }
}
