//
//  Loading.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import SwiftUI

struct Loading: View {
    @State private var isRotated: Bool = false
    
    var animation: Animation {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.5)
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            .fill(AppColors.accentColor)
            .frame(width: 80, height: 80)
            .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
            .animation(animation, value: isRotated)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .center)
            .onAppear{
                DispatchQueue.main.async {
                    self.isRotated.toggle()
                }
                
            }.onDisappear{
                DispatchQueue.main.async {
                    self.isRotated.toggle()
                }
            }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
