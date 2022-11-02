//
//  CountryCodeSelection.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import Foundation
import SwiftUI

struct CountryCodeSelection: View {
    
    @Binding var isPresented: Bool
    @Binding var country: String
    @Binding var code: String
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView( showsIndicators: false) {
                    LazyVStack( alignment: .leading) {
                        ForEach( Array( Credentials.countryCodeList.keys ).sorted(), id: \.self )  { key in
                            
                            Button {
                                code = Credentials.countryCodeList[key]!
                                country = key
                                isPresented.toggle()
                            } label: {
                                HStack {
                                    Text( countryName(countryCode: key) ?? "Undefined" )
                                        .font(.custom("Inter-Regular", size: 20))
                                        .foregroundColor(.black)
                                    
                                    Text( Credentials.countryCodeList[key]!)
                                        .font(.custom("Inter-Regular", size: 20))
                                            .foregroundColor(.black)
                                    
                                    Spacer()
                                }.padding(.horizontal)
                                .padding( .vertical, 8)
                            }
                            
                            Divider()
                        }
                    }
                }.padding( .top, 1 )
            }.navigationBarTitle( Text( NSLocalizedString("countryCode", comment: "") ), displayMode: .inline)
            .navigationBarItems(trailing: Button {
                self.isPresented.toggle()
            } label: {
                Text( NSLocalizedString("cancel", comment: "") )
            })
        }
    }
    
    func countryName(countryCode: String) -> String? {
            let current = Locale(identifier: "en_US")
            return current.localizedString(forRegionCode: countryCode)
        }
}

struct CountryCodeSelection_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodeSelection(isPresented: .constant( false ), country: .constant( "" ), code: .constant(""))
    }
}
