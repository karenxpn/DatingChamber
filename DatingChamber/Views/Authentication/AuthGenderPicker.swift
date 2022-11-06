//
//  AuthGenderPicker.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI

struct AuthGenderPicker: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var model: RegistrationModel
    
    let genders = [NSLocalizedString("female", comment: ""),
                   NSLocalizedString("male", comment: ""),
                   NSLocalizedString("non-binaryPerson", comment: "")]
    @State private var selected_gender = ""
    @State private var navigate: Bool = false
    @State private var showGender: Bool = true
    
    
    var body: some View {
        ZStack {
            VStack( alignment: .leading, spacing: 30) {
                
                TextHelper(text: NSLocalizedString("youAre", comment: ""),
                           fontName: "Inter-SemiBold",
                           fontSize: 30)
                
                ForEach( genders, id: \.self ) { gender in
                    
                    Button {
                        selected_gender = gender
                    } label: {
                        HStack {
                            TextHelper(text: gender,
                                       color: gender == selected_gender ? .white : .black,
                                       fontName: "Inter-SemiBold",
                                       fontSize: 18)
                            .padding(.leading)
                            
                            Spacer()
                        }.padding(.vertical, 14)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(gender == selected_gender ? AppColors.accent : .white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button {
                        showGender.toggle()
                    } label: {
                        ZStack {
                            Image("checkbox")
                            if !showGender {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 15, weight: .semibold))
                                
                            }
                        }
                    }
                    
                    TextHelper(text: NSLocalizedString("dontShowMyGender", comment: ""),
                    fontSize: 12)
                }
                
                ButtonHelper(disabled: selected_gender.isEmpty,
                             label: NSLocalizedString("continue", comment: "")) {
                    
                    navigate.toggle()
                    model.gender = selected_gender
                    model.showGender = showGender
                }.navigationDestination(isPresented: $navigate) {
                    AuthBio(model: $model)
                        .environmentObject(authVM)
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(30)
            
            AuthProgress(page: 2)
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct AuthGenderPicker_Previews: PreviewProvider {
    static var previews: some View {
        AuthGenderPicker(model: .constant(RegistrationModel()))
    }
}
