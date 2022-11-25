//
//  EditGender.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditGender: View {
    @StateObject var accountVM = AccountViewModel()
    @Binding var user: UserModelViewModel
    
    @State private var selected_gender: String = ""
    
    let genders = [NSLocalizedString("female", comment: ""),
                   NSLocalizedString("male", comment: ""),
                   NSLocalizedString("non-binaryPerson", comment: "")]
    
    
    var body: some View {
        EditProfileBuilder(title: NSLocalizedString("gender", comment: ""), showAlert: $accountVM.showAlert, message: accountVM.alertMessage) {
            VStack( alignment: .leading, spacing: 20) {
                
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
                            .cornerRadius(20)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                }
                
                Spacer()

                ButtonHelper(disabled: selected_gender.isEmpty || selected_gender == user.gender,
                             label: NSLocalizedString("continue", comment: "")) {
                    
                    user.gender = selected_gender
                    accountVM.updateAccount(field: ["gender" : selected_gender])
                }
            }
        }.task {
            selected_gender = user.gender
        }
    }
}

struct EditGender_Previews: PreviewProvider {
    static var previews: some View {
        EditGender(user: .constant(UserModelViewModel(user: AppPreviewModel.userModel)))
    }
}
