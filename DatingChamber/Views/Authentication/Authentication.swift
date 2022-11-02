//
//  Authentication.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI

struct Authentication: View {
    @StateObject var authVM = AuthViewModel()
    @State private var showPicker: Bool = false
//    @State private var model = RegistrationRequest()
    @State private var animate: Bool = false
    
    var body: some View {
        
        VStack( alignment: .leading, spacing: 20) {
            Text(NSLocalizedString("yourPhoneNumber", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
            
            Text(NSLocalizedString("fillInYourPhoneNumber", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .padding(.trailing)
            
            
            HStack {
                
                Button {
                    showPicker.toggle()
                    
                } label: {
                    HStack {
                        Text( "\(authVM.country) +\(authVM.code)" )
                            .foregroundColor(.black)
                            .font(.custom("Inter-SemiBold", size: 18))
                        
                        Image("dropdown")
                        
                    }.padding(.vertical, 15)
                        .padding(.horizontal, 10)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                
                TextField("(555) 555-1234", text: $authVM.phoneNumber)
                    .keyboardType(.phonePad)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
            }.padding(.top, 20)
            
            TermsOfUse(agreement: $authVM.agreement,
                       animate: $animate)
            
            Spacer()
            
            
            HStack {
                
                Spacer()
                
                ButtonHelper(disabled: authVM.phoneNumber == "" || authVM.loading,
                             label: NSLocalizedString("proceed", comment: "")) {
                    if authVM.agreement {
//                        authVM.sendVerificationCode()
                        
                    } else{
                        withAnimation(.easeInOut(duration: 0.7)) {
                            animate.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                animate.toggle()
                            }
                        }
                        
                    }
                }
            }.padding(.bottom, 30)
                .background(
//                    NavigationLink(destination: VerifyPhoneNumber(model: model, phone: "+\(authVM.code) \(authVM.phoneNumber)")
//                        .environmentObject(authVM), isActive: $authVM.navigate, label: {
//                            EmptyView()
//                        }).hidden()
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
             .sheet(isPresented: $showPicker) {
                 CountryCodeSelection(isPresented: $showPicker, country: $authVM.country, code: $authVM.code)
             }
             .alert(isPresented: $authVM.showAlert) {
                 Alert(title: Text(NSLocalizedString("error", comment: "")),
                       message: Text(authVM.alertMessage),
                       dismissButton: .default(Text(NSLocalizedString("gotIt", comment: ""))))
             }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
