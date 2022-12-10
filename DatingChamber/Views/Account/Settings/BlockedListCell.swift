//
//  BlockedListCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.12.22.
//

import SwiftUI

struct BlockedListCell: View {
    let user: UserPreviewViewModel
    var body: some View {
        HStack {
            
            ZStack(alignment: .bottomTrailing) {
                
                ImageHelper(image: user.image, contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                
                if user.online {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 15, height: 15)
                        
                        Circle()
                            .fill(AppColors.onlineStatus)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            VStack {
                TextHelper(text: user.name, fontName: "Inter-SemiBold" )
                    .lineLimit(1)
                
                TextHelper(text: user.lastVisit)
            }
            
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
    }
}

struct BlockedListCell_Previews: PreviewProvider {
    static var previews: some View {
        BlockedListCell(user: UserPreviewViewModel(user: AppPreviewModel.userPreviewModel))
    }
}
