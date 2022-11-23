//
//  EditProfileBuilder.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI

struct EditProfileBuilder<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    
    let title: String
    @Binding var showAlert: Bool
    let message: String
    private var content: Content
    
    init(title: String, showAlert: Binding<Bool>, message: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self._showAlert = showAlert
        self.message = message
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .leading)
            .padding(30)
            .padding(.bottom, UIScreen.main.bounds.size.height * 0.07)
            .navigationTitle(Text(""))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextHelper(text: title,
                               fontName: "Inter-Black",
                               fontSize: 24)
                    .kerning(0.56)
                    .padding(.bottom, 10)
                    .accessibilityAddTraits(.isHeader)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image("icon_settings")
                    }.padding(.bottom, 10)
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text( "Error" ), message: Text( message ), dismissButton: .default(Text( "Got It" )))
            }).onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "profile_updated"))) { _ in
                presentationMode.wrappedValue.dismiss()
            }
    }
}
