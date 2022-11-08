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
    let interests: [String]
    
    
    var body: some View {
        TagLayoutView(
            interests, tagFont: font,
            padding: 20, parentWidth: parentWidth) { tag in
                
                Text(tag)
                    .kerning(0.24)
                    .font(Font(font))
                    .fixedSize()
                    .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(AppColors.primary, lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                        )
                    )
                
            }
    }
}

struct TagsViewHelper_Previews: PreviewProvider {
    static var previews: some View {
        TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 8)!, parentWidth: UIScreen.main.bounds.width,interests: ["tea", "coffee", "travel", "dancing", "chill"])
    }
}
