//
//  AccountPreview.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import SwiftUI

struct AccountPreview: View {
    let user: UserModelViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 20) {
                ProfileImage(user: user)
                
                AccountName(name: user.name)
                
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
                
                // interests
                TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!, parentWidth: UIScreen.main.bounds.width, interests: user.interests.map{ InterestModel(same: true, name: $0)})
                
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .padding(30)
            
        }
    }
}

struct AccountPreview_Previews: PreviewProvider {
    static var previews: some View {
        AccountPreview(user: UserModelViewModel(user: AppPreviewModel.userModel) )
    }
}
