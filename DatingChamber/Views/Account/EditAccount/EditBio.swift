//
//  EditBio.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditBio: View {
    @StateObject var accountVM = AccountViewModel()
    @Binding var bio: String
    @FocusState var isInputActive: Bool

    var body: some View {
        VStack( alignment: .leading, spacing: 4) {
            
            HStack {
                
                TextHelper(text: NSLocalizedString("bio", comment: ""), fontName: "Inter-SemiBold", fontSize: 18)
                
                Spacer()
                
                Button {
                    isInputActive = true
                } label: {
                    TextHelper(text: NSLocalizedString("edit", comment: ""), color: AppColors.primary, fontSize: 12)
                        .padding(.leading)
                }

            }
            
            ZStack(alignment: .topLeading) {
                
                TextEditor(text: $bio)
                    .foregroundColor(Color.gray)
                    .font(.custom("Inter-Regular", size: 12))
                    .frame(height: 100)
                    .scrollContentBackground(.hidden)
                    .background(AppColors.light_red)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()

                            Button("Done") {
                                accountVM.updateAccount(field: ["bio" : bio])
                                isInputActive = false
                            }
                        }
                    }
                
                if bio.isEmpty {
                    
                    TextHelper(text: bio.isEmpty ? NSLocalizedString("tellAboutYou", comment: "") : bio, fontSize: 12)
                        .padding(10)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: .infinity,
                               alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.light_red)
                        )
                }
            }
            
            
            
        }.frame(minWidth: 0,
                   maxWidth: .infinity,
                   alignment: .leading)
    }
}

struct EditBio_Previews: PreviewProvider {
    static var previews: some View {
        EditBio(bio: .constant("Heelo"))
    }
}
