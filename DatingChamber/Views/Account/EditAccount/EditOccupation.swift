//
//  EditOccupation.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditOccupation: View {
    @StateObject var accountVM = AccountViewModel()
    @Binding var user: UserModelViewModel
    
    @State private var occupation: String = ""
    
    var body: some View {
        EditProfileBuilder(title: NSLocalizedString("occupation", comment: ""), showAlert: $accountVM.showAlert, message: accountVM.alertMessage) {
            VStack(alignment: .leading, spacing: 43) {
                TextHelper(text: NSLocalizedString("occupationMessage", comment: ""))
                TextFieldHelper(placeholder: NSLocalizedString("occupation", comment: ""), text: $occupation)
                
                Spacer()
                
                ButtonHelper(disabled: occupation == user.occupation,
                             label: NSLocalizedString("continue", comment: "")) {
                    user.occupation = occupation
                    accountVM.updateAccount(field: ["occupation": occupation])
                }
            }
        }.task {
            occupation = user.occupation
        }
    }
}

struct EditOccupation_Previews: PreviewProvider {
    static var previews: some View {
        EditOccupation(user: .constant(UserModelViewModel(user: AppPreviewModel.userModel)))
    }
}
