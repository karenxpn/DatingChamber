//
//  GeneralSettings.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import SwiftUI

struct GeneralSettings: View {
    var body: some View {
        VStack( spacing: 20 ) {
            
            ActionButtonHelper(label: NSLocalizedString("notifications", comment: "")) {

            }
            
            NavigationButtonHelper(label: NSLocalizedString("location", comment: ""), destination: AnyView(LocationRequest()))
            
            ActionButtonHelper(label: NSLocalizedString("blockedList", comment: "")) {

            }
            
            Spacer()
            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .leading)
        .padding(30)
        .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                TextHelper(text: NSLocalizedString("general", comment: ""),
                           fontName: "Inter-Black",
                           fontSize: 24)
                .kerning(0.56)
                .padding(.bottom, 10)
                .accessibilityAddTraits(.isHeader)
            }
        }.navigationTitle(Text(""))
    }
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
