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

    var body: some View {
        Button {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                userID = ""
                initialUserID = ""
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        } label: {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Log out")
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
    }
}
