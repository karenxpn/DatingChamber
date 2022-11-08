//
//  AuthInterests.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI
import TagLayoutView

struct AuthInterests: View {
    @StateObject var authVM = AuthViewModel()
    @Binding var model: RegistrationModel
    @State private var navigate: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 30) {
                
                TextHelper(text: NSLocalizedString("interests", comment: ""), fontName: "Inter-SemiBold", fontSize: 30)
                TextHelper(text: NSLocalizedString("chooseInterests", comment: ""))
                
                GeometryReader { geometry in
                    
                    ScrollView {
                        TagLayoutView(
                            authVM.interests, tagFont: UIFont(name: "Inter-SemiBold", size: 12)!,
                            padding: 20,
                            parentWidth: geometry.size.width) { tag in
                                
                                Button {
                                    
                                    if authVM.selected_interests.contains(where: {$0 == tag}) {
                                        authVM.selected_interests.removeAll(where: {$0 == tag})
                                    } else {
                                        authVM.selected_interests.append(tag)
                                    }
                                    
                                } label: {
                                    Text(tag)
                                        .fixedSize()
                                        .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                                        .foregroundColor( authVM.selected_interests.contains(where: {$0 == tag}) ? .white : AppColors.primary)
                                        .background(RoundedRectangle(cornerRadius: 30)
                                            .strokeBorder(AppColors.primary, lineWidth: 1.5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(authVM.selected_interests.contains(where: {$0 == tag}) ? AppColors.primary : .white )
                                            )
                                        )
                                    
                                }
                                
                            }.padding([.top, .trailing], 16)
                            .padding(.leading, 1)
                    }
                }
                    .overlay(
                        ProgressView().opacity(authVM.loading ? 1 : 0)
                    )
                
                
                ButtonHelper(disabled: (authVM.selected_interests.count < 3 || authVM.loading),
                             label: NSLocalizedString("continue", comment: "")) {
                    
                    model.interests = authVM.selected_interests
                    navigate = true
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
        }.task {
            authVM.getInterests()
        }.alert(isPresented: $authVM.showAlert) {
            Alert(title: Text( "Error" ), message: Text( authVM.alertMessage ), dismissButton: .default(Text( "OK" )))
        }
    }
}

struct AuthInterests_Previews: PreviewProvider {
    static var previews: some View {
        AuthInterests(model: .constant(RegistrationModel()))
            .environmentObject(AuthViewModel())
    }
}
