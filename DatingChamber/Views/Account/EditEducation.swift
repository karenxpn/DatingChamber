//
//  EditEducation.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditEducation: View {
    @StateObject var accountVM = AccountViewModel()
    @Binding var user: UserModelViewModel
    
    @State private var school: String = ""
    
    var body: some View {
        EditProfileBuilder(title: NSLocalizedString("education", comment: ""), showAlert: $accountVM.showAlert, message: accountVM.alertMessage) {
            VStack(alignment: .leading, spacing: 43) {
                
                TextHelper(text: NSLocalizedString("educationMessage", comment: ""))
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                TextFieldHelper(placeholder: NSLocalizedString("education", comment: ""), text: $school)
                
                Spacer()
                
                ButtonHelper(disabled: school == user.education,
                             label: NSLocalizedString("continue", comment: "")) {
                    user.education = school
                    accountVM.updateAccount(field: ["education": school])
                }
            }
        }.task {
            school = user.education
        }
    }
}

struct EditEducation_Previews: PreviewProvider {
    static var previews: some View {
        EditEducation(user: .constant(UserModelViewModel(user: AppPreviewModel.userModel)))
    }
}
