//
//  ContentView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @AppStorage("userID") var userID: String = ""
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        Group {
            if !userID.isEmpty {
                MainView()
            } else if authVM.needInformationFill {
                AuthName()
            } else {
                ProgressView()
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
