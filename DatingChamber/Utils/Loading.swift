//
//  Loading.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import SwiftUI
import ActivityIndicatorView

struct Loading<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack(spacing: 10) {
                    ProgressView()
                        .scaleEffect(1.5)
                    TextHelper(text: NSLocalizedString("loading", comment: ""))
                }
                .frame(width: geometry.size.width / 2.5,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading(isShowing: .constant(true)) {
            EmptyView()
        }
    }
}
