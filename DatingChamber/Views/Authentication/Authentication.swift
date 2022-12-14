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
                
                Spacer()
                TextHelper(text: NSLocalizedString("createYourLoveStory", comment: ""),
                           fontName: "Inter-SemiBold",
                           fontSize: 34)
                
                Spacer()
                
                
                TextHelper(text: NSLocalizedString("continueWithPhoneNumber", comment: ""),
                           fontName: "Inter-Medium",
                           fontSize: 20)
                .padding(.top, 16)
                
                HStack(spacing: 0) {
                    
                    Button {
                        showPicker.toggle()
                        
                    } label: {
                        HStack {
                            TextHelper(text: "\(authVM.country) +\(authVM.code)",
                                       fontName: "Inter-SemiBold")
                            
                        }.frame(height: 56)
                            .padding(.horizontal, 10)
                            .background(.white)
                            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 5, y: 5)
                    }
                    
                    TextField("(555) 555-1234", text: $authVM.phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.custom("Inter-SemiBold", size: 18))
                        .padding(.leading, 5)
                        .frame(height: 56)
                        .background(.white)
                        .cornerRadius(10, corners: [.topRight, .bottomRight])
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 5, y: 5)
                }
                
                
                TermsOfUse(agreement: $authVM.agreement,
                           animate: $animate)
                
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
                }.padding(.horizontal, 7)
                    .navigationDestination(isPresented: $authVM.navigate, destination: {
                        VerifyPhoneNumber(phone: "+\(authVM.code)\(authVM.phoneNumber)")
                            .environmentObject(authVM)
                    })
                
                Spacer()
                
                VStack(spacing: 16) {
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .frame(height: 1.2)
                        
                        TextHelper(text: NSLocalizedString("alternativeSignIn", comment: ""),
                                   color: .white,
                                   fontName: "Inter-Bold",
                                   fontSize: 12)
                        .padding(.horizontal, 8)
                        .lineLimit(1)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .frame(height: 1.2)
                    }
                    HStack {
                        Spacer()
                        AppleSignIn()
                            .environmentObject(authVM)
                        
                        Spacer()
                        
                        GoogleLogin()
                            .environmentObject(authVM)
                        Spacer()
                    }
                }
                
                
                
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
            .padding([.horizontal, .top], 30)
            .padding(.bottom, UIScreen.main.bounds.height * 0.08)
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
