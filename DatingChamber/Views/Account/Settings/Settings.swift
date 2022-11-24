//
//  Settings.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import SwiftUI

struct Settings: View {
    @StateObject private var accountVM = AccountViewModel()
    @State private var showDeleteAccountDialog: Bool = false

    var body: some View {
        VStack( spacing: 20 ) {
            
            NavigationButtonHelper(label: NSLocalizedString("general", comment: ""), destination: AnyView(GeneralSettings()))
            
            ActionButtonHelper(label: NSLocalizedString("privacy_policy", comment: "")) {
                if let url = URL(string: Credentials.privacy_policy) {
                    UIApplication.shared.open(url)
                }
            }
            
            ActionButtonHelper(label: NSLocalizedString("termsOfUse", comment: "")) {
                if let url = URL(string: Credentials.terms_of_use) {
                    UIApplication.shared.open(url)
                }
            }
            
            ActionButtonHelper(label: NSLocalizedString("help", comment: "")) {
                if let url = URL(string: "mailto:support@datingchamper.com") {
                    UIApplication.shared.open(url)
                }
            }

            Spacer()
            
            ButtonHelper(disabled: false,
                         label: NSLocalizedString("signOut", comment: "")) {
                accountVM.signOut()
            }
            
            
            Button {
                showDeleteAccountDialog.toggle()
            } label: {
                Text( NSLocalizedString("deleteAccount", comment: ""))
                    .foregroundColor(.red)
                    .font(.custom("Inter-SemiBold", size: 18))
                
            }
            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .leading)
        .padding(30)
        .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
        .alert(isPresented: $showDeleteAccountDialog) {
                    Alert(title: Text( NSLocalizedString("deleteAccount", comment: "")),
                          message: Text( NSLocalizedString("afterDeletion", comment: "")),
                          primaryButton: .cancel(Text(NSLocalizedString("no", comment: ""))),
                          secondaryButton: .default(Text( NSLocalizedString("yes", comment: "")), action: {
//                        profileVM.deactivateAccount()
                    }))
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                TextHelper(text: NSLocalizedString("settings", comment: ""),
                           fontName: "Inter-Black",
                           fontSize: 24)
                .kerning(0.56)
                .padding(.bottom, 10)
                .accessibilityAddTraits(.isHeader)
            }
        }.navigationTitle(Text(""))
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
