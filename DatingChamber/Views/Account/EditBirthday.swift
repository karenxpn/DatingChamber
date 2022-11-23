//
//  EditBirthday.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditBirthday: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var accountVM = AccountViewModel()
    @Binding var user: UserModelViewModel
    @State private var date = Date()
    
    let dateMinLimit = Calendar.current.date(byAdding: .year, value: -17, to: Date()) ?? Date()
    let dateMaxLimit = Calendar.current.date(byAdding: .year, value: -150, to: Date()) ?? Date()

    var body: some View {
        
        VStack {
            
            TextHelper(text: NSLocalizedString("birthday", comment: ""))
            
            DatePicker(
                "Start Date",
                selection: $date,
                in: dateMaxLimit...dateMinLimit,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(AppColors.primary)
            .environment(\.locale, Locale.init(identifier: "en_US"))

            
            ButtonHelper(disabled: user.birthday == date, label: NSLocalizedString("continue", comment: "")) {
                user.birthday = date
                print(user.birthday)
                accountVM.updateAccount(field: ["birthday" : date])
            }
            
        }.padding(30)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "profile_updated"))) { _ in
                presentationMode.wrappedValue.dismiss()
            }

    }
}

struct EditBirthday_Previews: PreviewProvider {
    static var previews: some View {
        EditBirthday(user: .constant(UserModelViewModel(user: AppPreviewModel.userModel)))
    }
}
