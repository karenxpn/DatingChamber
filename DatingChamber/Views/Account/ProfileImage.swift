//
//  ProfileImage.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import SwiftUI

struct ProfileImage: View {
    let user: UserModelViewModel
    var body: some View {
        ZStack( alignment: .bottomTrailing) {
            
                ImageHelper(image: user.avatar, contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())

                            
            NavigationLink(destination: EditAccount()) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .fill(.white)
                        .frame(width: 30, height: 30)
                    
                    Image("edit_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .padding(10)
                        .background(AppColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .shadow(radius: 2)
    //                    .offset(x: 15, y: -15)
                    

                }

            }
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(user: UserModelViewModel(user: AppPreviewModel.userModel))
    }
}
