//
//  AuthProfileImages.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI


import SwiftUI

struct AuthProfileImages: View {
    @StateObject private var authVM = AuthViewModel()
    @Binding var model: RegistrationModel
    
    @State private var navigate: Bool = false
    @State private var showPicker: Bool = false
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            ZStack {
                
                ScrollView(showsIndicators: false) {
                    VStack( alignment: .leading, spacing: 30) {
                        
                        TextHelper(text: NSLocalizedString("photo", comment: ""),
                        fontName: "Inter-SemiBold",
                        fontSize: 30)
                        
                        TextHelper(text: NSLocalizedString("uploadMinTwoPhotos", comment: ""))
                        
                        
                        HStack(spacing: 30) {
                            ForEach(0...1, id: \.self) { index in
                                
                                ProfileImageBox(images: $authVM.images, showPicker: $showPicker,
                                                height: UIScreen.main.bounds.size.height * 0.22,
                                                width:  UIScreen.main.bounds.size.width * 0.38,
                                                index: index)
                                .environmentObject(authVM)
                            }
                        }
                        
                        HStack(spacing: 30) {
                            ForEach(2...4, id: \.self) { index in
                                
                                ProfileImageBox(images: $authVM.images, showPicker: $showPicker,
                                                height: UIScreen.main.bounds.size.height * 0.14,
                                                width:  UIScreen.main.bounds.size.width * 0.23,
                                                index: index)
                                .environmentObject(authVM)
                            }
                        }
                        
                        TextHelper(text: NSLocalizedString("youWillBeAbleToChangePhoto", comment: ""),
                        fontSize: 12)
                        
                        Spacer()
                        
                        ButtonHelper(disabled: authVM.images.count < 2,
                                     label: NSLocalizedString("continue", comment: "")) {
                            model.images = authVM.images
                            model.profileImage = authVM.images[0]
                            authVM.storeUser(model: model)
                        }
                        
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(30)
                }.padding(.top, 1)
                
                AuthProgress(page: 3)
            }
        }.navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showPicker) {
                Gallery(action: { images in
                    authVM.uploadImages(images: images)
//                    authVM.getPreSignedURL(images: images)
                }, existingImageCount: authVM.images.count)
            }.alert(isPresented: $authVM.showAlert) {
                Alert(title: Text( "Error" ), message: Text( authVM.alertMessage), dismissButton: .cancel(Text( "Got It!" )))
            }
    }
}

struct AuthProfileImages_Previews: PreviewProvider {
    static var previews: some View {
        AuthProfileImages(model: .constant(RegistrationModel()))
    }
}
