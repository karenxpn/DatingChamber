//
//  Account.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI
import FirebaseAuth

struct Account: View {
    @AppStorage("userID") var userID: String = ""
    @AppStorage("initialuserID") var initialUserID: String = ""
    @StateObject private var accountVM = AccountViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if accountVM.loading {
                    ProgressView()
                } else if accountVM.user != nil {
                    AccountPreview(user: accountVM.user!)

                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextHelper(text: NSLocalizedString("profile", comment: ""),
                               fontName: "Inter-Black",
                               fontSize: 24)
                    .kerning(0.56)
                    .accessibilityAddTraits(.isHeader)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image("icon_settings")
                    }
                }
            }.navigationTitle(Text(""))
            .task {
                accountVM.getAccount()
            }.alert(isPresented: $accountVM.showAlert) {
                Alert(title: Text(NSLocalizedString("error", comment: "")),
                      message: Text(accountVM.alertMessage),
                      dismissButton: .default(Text(NSLocalizedString("gotIt", comment: ""))))
            }
        }
//        Button {
//            let firebaseAuth = Auth.auth()
//            do {
//                try firebaseAuth.signOut()
//                userID = ""
//                initialUserID = ""
//            } catch let signOutError as NSError {
//                print("Error signing out: %@", signOutError)
//            }
//        } label: {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Log out")
//        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
    }
}
