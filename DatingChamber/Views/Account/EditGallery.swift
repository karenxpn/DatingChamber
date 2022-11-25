//
//  EditGallery.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 24.11.22.
//

import SwiftUI
import Popovers

struct EditGallery: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var accountVM = AccountViewModel()
    @State var user: UserModelViewModel
    @State private var showPicker: Bool = false
    @State private var showPopover: Bool = false
    
    var body: some View {
        Loading(isShowing: $accountVM.loading) {
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 20 ) {
                    ZStack {
                        ImageHelper(image: user.avatar, contentMode: .fill)
                            .frame(width: 148, height: 148)
                            .clipShape(Circle())
                            .padding()
                        
                        Circle()
                            .strokeBorder(AppColors.primary,lineWidth: 9)
                    }
                    
                    TextHelper(text: NSLocalizedString("uploadMinTwoPhotos", comment: ""))
                    
                    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<9, id: \.self) { index in
                            ProfileImageBox(images: $accountVM.uploadedImages, showPicker: $showPicker, height: 92, width: 92, index: index) { image in
                                accountVM.updateAvatar(image: image)
                            }
                        }
                    }
                    
                    ButtonHelper(disabled: accountVM.uploadedImages.count < 2 ||
                                 accountVM.uploadedImages == user.images, label: NSLocalizedString("continue", comment: "")) {
                        
                        accountVM.updateAccount(field: ["images" : accountVM.uploadedImages])
                        
                    }
                    
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding(30)
                .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                
            }.padding(.top, 1)
        }.sheet(isPresented: $showPicker) {
            Gallery(action: { images in
                accountVM.uploadImages(images: images)
            }, existingImageCount: user.images.count, limit: 9)
        }.task {
            accountVM.uploadedImages = user.images
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "profile_updated"))) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct EditGallery_Previews: PreviewProvider {
    static var previews: some View {
        EditGallery(user: UserModelViewModel(user: AppPreviewModel.userModel))
    }
}
