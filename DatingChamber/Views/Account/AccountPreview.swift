//
//  AccountPreview.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import SwiftUI

struct AccountPreview: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @State var user: UserModelViewModel
    let icons = ["occupation_icon", "education_icon", "gender_icon", "city_icon"]
    let names = [NSLocalizedString("occupation", comment: ""),
                 NSLocalizedString("education", comment: ""),
                 NSLocalizedString("gender", comment: ""),
                 NSLocalizedString("city", comment: "")]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            ProfileImage(user: user)
                
            VStack(spacing: 26) {
                TextHelper(text: "\(user.name), \(user.age)", fontName: "Inter-SemiBold", fontSize: 20)

                // bio
                if !user.bio.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        TextHelper(text: NSLocalizedString("bio", comment: ""), fontName: "Inter-SemiBold", fontSize: 18)
                        TextHelper(text: user.bio, fontSize: 12)
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                }
                
                // specs here                
                VStack( spacing: 5) {
                    AccountSpecs(icon: icons[0], label: names[0], value: user.occupation, destination: AnyView(EditOccupation(user: $user)), iconColor: AppColors.primary)
                    AccountSpecs(icon: icons[1], label: names[1], value: user.education, destination: AnyView(EditEducation(user: $user)), iconColor: AppColors.primary)
                    AccountSpecs(icon: icons[2], label: names[2], value: user.gender, destination: AnyView(EditGender(user: $user)), iconColor: AppColors.primary)
                    AccountSpecs(icon: icons[3], label: names[3], value: user.city, destination: AnyView(EditCity(user: $user)), iconColor: AppColors.primary)
                }
                
                // interests
                TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!, parentWidth: UIScreen.main.bounds.width * 0.8, interests: user.interests.map{ InterestModel(same: true, name: $0)})
                
                if !accountVM.posts.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        TextHelper(text: NSLocalizedString("posts", comment: ""), fontName: "Inter-SemiBold", fontSize: 18)
                        PostsGrid(posts: accountVM.posts)
                    }

                }
                if accountVM.loadingPost {
                    ProgressView()
                }
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .padding(30)
            .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            .offset(y: 50)
            
        }.padding(.top, 1)
    }
}

struct AccountPreview_Previews: PreviewProvider {
    static var previews: some View {
        AccountPreview(user: UserModelViewModel(user: AppPreviewModel.userModel) )
    }
}
