//
//  GoogleLogin.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 04.11.22.
//

import SwiftUI

struct GoogleLogin: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        
        Button {
            authVM.googleSignin(viewController: getRootViewController())
        } label: {
            Image("google_logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .foregroundColor(.black)
                .padding(.vertical, 20)
                .padding(.horizontal, UIScreen.main.bounds.width * 0.15)                .background(RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(.gray, lineWidth: 2)
                    .shadow(radius: 2, x: 0, y: 2))
        }
    }
}

struct GoogleLogin_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLogin()
            .environmentObject(AuthViewModel())
    }
}
