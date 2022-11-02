//
//  VerifyPhoneNumber.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import SwiftUI

struct VerifyPhoneNumber: View {
    @EnvironmentObject var authVM: AuthViewModel
//    @State var model: RegistrationRequest
    let phone: String
    
    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            
            TextHelper(text: NSLocalizedString("code", comment: ""),
                       fontName: "Inter-SemiBold", fontSize: 30)
            
            TextHelper(text: NSLocalizedString("codeWasSent", comment: "") + phone)
                .padding(.top, 20)
                .padding(.bottom, 50)
            
            
            OTPTextFieldView { otp in
                UIApplication.shared.endEditing()
                authVM.OTP = otp
            }
            
            
            
            Spacer()
            
            
            ButtonHelper(disabled: authVM.OTP.count != 6,
                         label: NSLocalizedString("proceed", comment: "")) {
                authVM.checkVerificationCode()
            }.background(
//                    NavigationLink(destination: AuthNameInput(model: model), isActive: $authVM.proceedRegistration, label: {
//                        EmptyView()
//                    }).hidden()
                )
            
            
        }.navigationBarTitle("", displayMode: .inline)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(30)
            .alert(isPresented: $authVM.showAlert) {
                Alert(title: Text("Error"), message: Text(authVM.alertMessage), dismissButton: .default(Text("Got it!")))
            }
    }
}

struct VerifyPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        VerifyPhoneNumber(phone: "92837408237")
    }
}
