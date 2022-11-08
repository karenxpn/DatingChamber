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
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.size.width * 0.3, height: 47)
                .background(RoundedRectangle(cornerRadius: 12)
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
