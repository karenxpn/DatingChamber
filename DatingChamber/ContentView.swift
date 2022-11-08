//
//  ContentView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        Group {
            if authVM.loading {
                ProgressView()
            } else if authVM.needInformationFill {
                AuthName()
            } else {
                Button {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
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
        }.task {
            authVM.checkExistence()
        }.alert(isPresented: $authVM.showAlert) {
            Alert(title: Text(NSLocalizedString("error", comment: "")),
                  message: Text(authVM.alertMessage),
                  dismissButton: .default(Text(NSLocalizedString("gotIt", comment: ""))))
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        ).onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "passedRegistration"))) { _ in
            authVM.checkExistence()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
