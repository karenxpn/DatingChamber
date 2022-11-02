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
                    .font(.custom("Inter-SemiBold", size: 70))
                    .padding(6)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack {
                    Spacer()

                    NavigationLink {
                        Authentication()
                    } label: {
                        HStack {
                            Spacer()
                            
                            TextHelper(text: NSLocalizedString("continue", comment: ""), color: .white, fontName: "Inter-SemiBold", fontSize: 20)
                                .padding(.vertical, 15)
                            
                            Spacer()
                        }.background(AppColors.proceedButtonColor)
                            .cornerRadius(30)
                            .padding(.bottom, 30)
                    }

                }.padding(.horizontal, 30)

                
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
