//
//  EditAccount.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import SwiftUI

struct EditAccount: View {
    @StateObject private var accountVM = AccountViewModel()
    
    var body: some View {
        ZStack {
            if accountVM.loading {
                ProgressView()
            } else if accountVM.user != nil {
                EditAccountInnerView(user: accountVM.user!)
            }
        }.task {
            accountVM.getAccount()
        }.navigationTitle(Text(""))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                TextHelper(text: NSLocalizedString("profile", comment: ""),
                           fontName: "Inter-Black",
                           fontSize: 24)
                .kerning(0.56)
                .accessibilityAddTraits(.isHeader)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    Settings()
                } label: {
                    Image("icon_settings")
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

struct EditAccount_Previews: PreviewProvider {
    static var previews: some View {
        EditAccount()
    }
}
