//
//  EditCity.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditCity: View {
    @StateObject var accountVM = AccountViewModel()
    @Binding var user: UserModelViewModel
    
    @State private var city: String = ""
    
    var body: some View {
        EditProfileBuilder(title: NSLocalizedString("city", comment: ""), showAlert: $accountVM.showAlert, message: accountVM.alertMessage) {
            VStack(alignment: .leading, spacing: 43) {
                TextHelper(text: NSLocalizedString("cityMessage", comment: ""))
                
                TextFieldHelper(placeholder: NSLocalizedString("city", comment: ""), text: $city)
                
                Spacer()
                
                ButtonHelper(disabled: city == user.city,
                             label: NSLocalizedString("continue", comment: "")) {
                    user.city = city
                    accountVM.updateAccount(field: ["city": city])
                }
            }
        }.task {
            city = user.city
        }
    }
}

struct EditCity_Previews: PreviewProvider {
    static var previews: some View {
        EditCity(user: .constant(UserModelViewModel(user: AppPreviewModel.userModel)))
    }
}
