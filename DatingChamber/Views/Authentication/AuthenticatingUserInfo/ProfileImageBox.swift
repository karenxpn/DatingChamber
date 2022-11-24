//
//  ProfileImageBox.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI
import Popovers

struct ProfileImageBox: View {
    @AppStorage("userID") var userID: String = ""

    @Binding var images: [String]
    @Binding var showPicker: Bool
    let height: CGFloat
    let width: CGFloat
    let index: Int
    let setAvatar: ((String) -> (Void))
    
    @State private var showPopover: Bool = false
    
    var body: some View {
        
        if images.count > index {
            ZStack( alignment: .bottomLeading) {
                
                ZStack( alignment: .topTrailing) {
                    
                    ImageHelper(image: images[index], contentMode: .fill)
                        .frame(width: width,
                               height: height)
                        .clipped()
                        .cornerRadius(10)
                        .onTapGesture {
                            if !userID.isEmpty {
                                showPopover.toggle()
                            }
                        }.popover(
                            present: $showPopover,
                            attributes: {
                                $0.position = .absolute(
                                    originAnchor: .bottom,
                                    popoverAnchor: .top
                                )
                            }
                        ) {
                            VStack(alignment: .leading, spacing: 0) {
                                MenuButtonsHelper(label: NSLocalizedString("makeAvatar", comment: ""), role: .cancel) {
                                    setAvatar(images[index])
                                    showPopover.toggle()
                                }
                                
                            }.frame(width: 200)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                    
                    
                    Button {
                        images.remove(at: index)
                    } label: {
                        Image("delete_icon")
                            .offset(x: 5, y: -5)
                    }
                }
                
                if index == 0 {
                    TextHelper(text: NSLocalizedString("avatar", comment: ""),
                               color: .white,
                               fontSize: 8)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 7.5)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(4)
                    .padding(6)
                }
            }.frame(width: width, height: height)
        } else {
            Button {
                showPicker.toggle()
            } label: {
                Image("add_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
                    .foregroundColor(AppColors.primary)
                    .frame(width: width, height: height)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(AppColors.light_blue, style: StrokeStyle(lineWidth: 1, dash: [10]))

                    )
            }
        }
    }
}
