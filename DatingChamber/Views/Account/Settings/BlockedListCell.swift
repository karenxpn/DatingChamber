//
//  BlockedListCell.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.12.22.
//

import SwiftUI

struct BlockedListCell: View {
    let user: BlockedUserModel
    var body: some View {
        HStack(spacing: 15) {
            
            ImageHelper(image: user.image, contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            TextHelper(text: user.name, fontName: "Inter-SemiBold")
            
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
    }
}

struct BlockedListCell_Previews: PreviewProvider {
    static var previews: some View {
        BlockedListCell(user: BlockedUserModel(id: "id", name: "Karen", image: Credentials.default_story_image))
    }
}
