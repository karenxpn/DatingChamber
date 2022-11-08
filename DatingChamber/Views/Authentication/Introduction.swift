//
//  Introduction.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI

struct Introduction: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("introduction")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)

                Text("Dating Chamber")
                    .foregroundColor(.white)
                    .font(.custom("Inter-Black", size: 64))
                    .padding(6)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                
                VStack {
                    Spacer()

                    NavigationLink {
                        Authentication()
                    } label: {
                        HStack {
                            Spacer()
                            
                            TextHelper(text: NSLocalizedString("continue", comment: ""), color: .white, fontName: "Inter-SemiBold", fontSize: 22)
                                .padding(.vertical, 15)
                            
                            Spacer()
                        }.background(AppColors.primary)
                            .cornerRadius(30)
                            .padding(.horizontal, 7)
                            .padding(.bottom, UIScreen.main.bounds.height * 0.08)
                    }

                }.padding(.horizontal, 35)

                
            }.navigationBarHidden(true)
                .navigationBarTitle("")
        }.gesture(DragGesture().onChanged({ _ in
            UIApplication.shared.endEditing()
        }))
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()
    }
}
