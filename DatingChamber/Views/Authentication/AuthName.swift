//
//  AuthName.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI

import SwiftUI

struct AuthName: View {
    @AppStorage("name") var local_name: String = ""

    @State private var model = RegistrationModel()
    @State private var name: String = ""
    @State private var navigate: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack( alignment: .leading, spacing: 30) {
                    
                    TextHelper(text: NSLocalizedString("yourName", comment: ""),
                               fontName: "Inter-SemiBold", fontSize: 30)
                    
                    TextHelper(text: NSLocalizedString("thisNameWillBeDisplayed", comment: ""))
                    
                    TextField(NSLocalizedString("whatsYourName", comment: ""), text: $name)
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 18))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 10)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                    TextHelper(text: NSLocalizedString("nameWillNotBeChanged", comment: ""), fontSize: 12)
                        .font(.custom("Inter-Regular", size: 12))
                    
                    
                    Spacer()
                    
                    ButtonHelper(disabled: name.count < 3,
                                 label: NSLocalizedString("continue", comment: "")) {
                        model.name = name
                        local_name = name
                        navigate.toggle()
                    }.navigationDestination(isPresented: $navigate) {
                        AuthBirthday(model: $model)
                    }
                    
                }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                .padding([.horizontal, .top], 30)
                .padding(.bottom, UIScreen.main.bounds.height * 0.08)
                
                AuthProgress(page: 0)
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
                .navigationBarTitle("")
                .onAppear {
                    model.name = local_name
                }
        }.gesture(DragGesture().onChanged({ _ in
            UIApplication.shared.endEditing()
        }))

    }
}
struct AuthName_Previews: PreviewProvider {
    static var previews: some View {
        AuthName()
            .environmentObject(AuthViewModel())
    }
}
