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
                .frame(width: UIScreen.main.bounds.size.width * 0.3, height: 47)
                .background(RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.gray, lineWidth: 2))
        }
    }
}

struct GoogleLogin_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLogin()
            .environmentObject(AuthViewModel())
    }
}
