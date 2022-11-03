//
//  AppleSignIn.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 03.11.22.
//

import SwiftUI
import FirebaseService

struct AppleSignIn: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var appleService = FirebaseSignInWithAppleService()
    var body: some View {
        
        Button {
            authenticate()
        } label: {
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(.gray, lineWidth: 2))
        }
    }
    
    func authenticate() {
        appleService.signIn { result in
            authVM.handleAppleServiceSuccess(result)
        } onFailed: { error in
            authVM.handleAppleServiceError(error)
        }
    }
}

struct AppleSignIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleSignIn()
    }
}
