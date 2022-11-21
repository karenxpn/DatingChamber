//
//  SwipeOnlineAndVerified.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

struct SwipeOnlineAndVerified: View {
    let isVerified: Bool
    let online: Bool
    
    var body: some View {
        VStack( alignment: .leading) {
            
            
            if isVerified {
                HStack {
                    Image("verified_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                    
                    TextHelper(text: NSLocalizedString("verified", comment: ""), color: .white, fontSize: 8)
                }.padding(.horizontal, 9)
                    .frame(height: 21)
                    .background(.white.opacity(0.3))
                    .cornerRadius(20)
            }
            
            if online {
                HStack {
                    Circle()
                        .fill(AppColors.onlineStatus)
                        .frame(width: 6, height: 6)
                    
                    TextHelper(text: NSLocalizedString("online", comment: ""), color: .white, fontSize: 8)

                }.padding(.horizontal, 9)
                    .frame(height: 21)
                    .background(.white.opacity(0.3))
                    .cornerRadius(20)
            }
            
        }
    }
}

struct SwipeOnlineAndVerified_Previews: PreviewProvider {
    static var previews: some View {
        SwipeOnlineAndVerified(isVerified: false, online: true)
    }
}
