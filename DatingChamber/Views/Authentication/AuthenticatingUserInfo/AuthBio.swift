//
//  AuthBio.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI


import SwiftUI

struct AuthBio: View {
    @StateObject var authVM = AuthViewModel()
    @Binding var model: RegistrationModel
    @State private var navigate: Bool = false
    
    @State private var bio: String = ""
    var body: some View {
        ZStack {
            
            VStack( alignment: .leading, spacing: 30) {
                
                TextHelper(text: NSLocalizedString("aboutYou", comment: ""),
                fontName: "Inter-SemiBold",
                fontSize: 30)
                
                ZStack(alignment: .leading) {
                    
                    TextEditor(text: $bio)
                        .foregroundColor(Color.white)
                        .font(.custom("Inter-Regular", size: 16))
                        .frame(height: 150)
                        .scrollContentBackground(.hidden)
                        .background(AppColors.accent)
                        .cornerRadius(10)
                    
                    if bio.isEmpty {
                        
                        VStack {
                            TextHelper(text: NSLocalizedString("tellAboutYou", comment: ""),
                                       color: Color.white)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                            Spacer()
                        }.frame(height: 150)
                    }
                }
                
                TextHelper(text: NSLocalizedString("youCanModifyLater", comment: ""), fontSize: 12)
                
                Spacer()
                
                ButtonHelper(disabled: bio.isEmpty,
                             label: NSLocalizedString("continue", comment: "")) {
                    model.bio = bio
                    navigate.toggle()
//                    authVM.storeUser(model: model)
                }.navigationDestination(isPresented: $navigate) {
                    AuthProfileImages(model: $model)
                }
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
                .padding(30)
            
            AuthProgress(page: 3)
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                // can finish the registration
                navigate.toggle()
            }, label: {
                TextHelper(text: NSLocalizedString("skip", comment: ""),
                           color: AppColors.accent,
                           fontName: "Inter-SemiBold",
                           fontSize: 18)
            }))
    }
}

struct AuthBio_Previews: PreviewProvider {
    static var previews: some View {
        AuthBio(model: .constant(RegistrationModel()))
    }
}
