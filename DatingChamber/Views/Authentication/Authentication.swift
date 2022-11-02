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
    @State private var animate: Bool = false
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 20) {
                    TextHelper(text: NSLocalizedString("yourPhoneNumber", comment: ""),
                               fontName: "Inter-SemiBold",
                               fontSize: 30)
                    .fixedSize(horizontal: false, vertical: true)

                    
                    TextHelper(text: NSLocalizedString("fillInYourPhoneNumber", comment: ""))
                        .padding(.trailing)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack {
                        
                        Button {
                            showPicker.toggle()
                            
                        } label: {
                            HStack {
                                TextHelper(text: "\(authVM.country) +\(authVM.code)",
                                           fontName: "Inter-SemiBold",
                                           fontSize: 18)
                                
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
                                     label: NSLocalizedString("continue", comment: "")) {
                            if authVM.agreement {
                                authVM.sendVerificationCode()
                                
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
                    }.navigationDestination(isPresented: $authVM.navigate, destination: {
                            VerifyPhoneNumber(phone: "+\(authVM.code)\(authVM.phoneNumber)")
                                .environmentObject(authVM)
                        })
                    
                }
        }.navigationBarHidden(true)
            .navigationBarTitle("")
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
