//
//  TagsViewHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI
import TagLayoutView

struct TagsViewHelper: View {
    
    let font: UIFont
    let parentWidth: CGFloat
    let interests: [InterestModel]
    
    
    var body: some View {
        TagLayoutView(
            interests.map{ $0.name}, tagFont: font,
            padding: 20, parentWidth: parentWidth) { tag in
                
                Text(tag)
                    .kerning(0.24)
                    .font(Font(font))
                    .fixedSize()
                    .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(interests.contains(where: {$0.name == tag && $0.same == true}) ? AppColors.primary : .gray.opacity(0.5))
                    )
                
            }
    }
}
