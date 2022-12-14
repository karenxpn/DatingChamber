//
//  EditInterests.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI
import TagLayoutView

struct EditInterests: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var accountVM = AccountViewModel()
    @State var user: UserModelViewModel
    @State private var selectedInterests = [String]()
    
    
    var body: some View {
        
        EditProfileBuilder(title: NSLocalizedString("interests", comment: ""), showAlert: $accountVM.showAlert, message: accountVM.alertMessage) {
            ZStack {
                if accountVM.loading {
                    ProgressView()
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        TextHelper(text: NSLocalizedString("yourInterests", comment: ""), fontName: "Inter-Black", fontSize: 24)
                        TextHelper(text: NSLocalizedString("selectInterests", comment: ""), fontSize: 12)
                        
                        ScrollView(showsIndicators: false) {
                            TagLayoutView(
                                accountVM.interests, tagFont: UIFont(name: "Inter-Regular", size: 12)!,
                                padding: 20,
                                parentWidth: UIScreen.main.bounds.size.width * 0.8) { tag in
                                    
                                    Button {
                                        
                                        if selectedInterests.contains(where: {$0 == tag}) {
                                            selectedInterests.removeAll(where: {$0 == tag})
                                        } else {
                                            selectedInterests.append(tag)
                                        }
                                        
                                    } label: {
                                        Text(tag)
                                            .fixedSize()
                                            .font(.custom("Inter-Regular", size: 12))
                                            .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                                            .foregroundColor( selectedInterests.contains(where: {$0 == tag}) ? .white : AppColors.primary)
                                            .background(RoundedRectangle(cornerRadius: 30)
                                                .strokeBorder(AppColors.primary, lineWidth: 1.5)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .fill(selectedInterests.contains(where: {$0 == tag}) ? AppColors.primary : .white )
                                                )
                                            )
                                        
                                    }
                                    
                                }.padding([.top, .trailing], 16)
                                .padding(.leading, 1)
                        }
                        
                        ButtonHelper(disabled: (selectedInterests.count < 3 ||
                                                selectedInterests.containsSameElements(as: user.interests)),
                                     label: NSLocalizedString("continue", comment: "")) {
                            
                            user.interests = selectedInterests
                            accountVM.updateAccount(field: ["interests" : selectedInterests])
                        }
                    }
                }
            }
        }.task {
            selectedInterests = user.interests
            accountVM.getInterests()
        }
    }
}

//struct EditInterests_Previews: PreviewProvider {
//    static var previews: some View {
//        EditInterests()
//    }
//}
