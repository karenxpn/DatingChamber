//
//  TextHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import SwiftUI

struct TextHelper: View {
    let text: String
    let color: Color
    let fontName: String
    let fontSize: CGFloat
    let font: Font
    
    init(text: String, color: Color = .black, fontName: String = "Inter-Regular", fontSize: CGFloat = 16) {
        self.text = text
        self.color = color
        self.fontName = fontName
        self.fontSize =  fontSize
        self.font = .custom(fontName, size: fontSize)
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(font)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct TextHelper_Previews: PreviewProvider {
    static var previews: some View {
        TextHelper(text: "some text")
    }
}
