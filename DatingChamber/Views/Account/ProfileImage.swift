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
        
        ZStack(alignment: .bottom) {
            Image("account_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
//                .overlay(LinearGradient(gradient:
//                                            Gradient(colors: [.clear, .clear, .gray]),
//                                        startPoint: .top, endPoint: .bottom))
                .frame(width: UIScreen.main.bounds.size.width,
                       height: UIScreen.main.bounds.size.height * 0.3)
                .clipped()
            
            ZStack( alignment: .bottomTrailing) {
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .fill(.white)
                        .frame(width: 140, height: 140)
                    
                    ImageHelper(image: user.avatar, contentMode: .fill)
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                }

                
                
                NavigationLink(destination: EditAccount()) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .fill(.white)
                            .frame(width: 25, height: 25)
                        
                        Image("edit_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 11, height: 11)
                            .padding(10)
                            .background(AppColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                            .shadow(radius: 2)
                        //                    .offset(x: 15, y: -15)
                        
                        
                    }
                    
                }
            }.offset(y: 70)
        }

    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(user: UserModelViewModel(user: AppPreviewModel.userModel))
    }
}
