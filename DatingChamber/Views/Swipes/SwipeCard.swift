//
//  SwipeCard.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

enum CardAction {
    case dislike, like, star
}

struct SwipeCard: View {
    @State var user: SwipeUserViewModel
    @State private var navigate: Bool = false
    @State private var showDialog: Bool = false
    @State private var showReportConfirmation: Bool = false
    @State private var starredRotationDegree: Double = 360
    @State private var cardAction: CardAction? = .none

    
    let animation = Animation
        .interpolatingSpring(mass: 1.0,
                             stiffness: 50,
                             damping: 8,
                             initialVelocity: 0)
        .speed(0.5)
    
    var body: some View {
        
        VStack( spacing: 20) {
            
            ZStack( alignment: .leading) {
                
                ImageHelper(image: user.avatar, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.55)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                
                VStack( alignment: .leading, spacing: 8) {
                    
                    HStack( alignment: .top) {
                        
                        SwipeOnlineAndVerified(isVerified: user.isVerified, online: user.online)
                        
                        Spacer()
                        
                        Button {
                            showDialog.toggle()
                        } label: {
                            Image("dots")
                                .foregroundColor(.white)
                        }.fullScreenCover(isPresented: $showDialog) {
                            CustomActionSheet {
                                
                                ActionSheetButtonHelper(icon: "report_icon",
                                                        label: NSLocalizedString("report", comment: ""),
                                                        role: .destructive) {
                                    self.showReportConfirmation.toggle()
                                }.alert(NSLocalizedString("chooseReason", comment: ""), isPresented: $showReportConfirmation, actions: {
                                    Button {
//                                        userVM.reportReason = NSLocalizedString("fraud", comment: "")
                                        reportUser()

                                    } label: {
                                        Text( NSLocalizedString("fraud", comment: "") )
                                    }
                                    
                                    Button {
//                                        userVM.reportReason = NSLocalizedString("insults", comment: "")
                                        reportUser()
                                    } label: {
                                        Text( NSLocalizedString("insults", comment: "") )
                                    }
                                    
                                    Button {
//                                        userVM.reportReason = NSLocalizedString("fakeAccount", comment: "")
                                        reportUser()
                                    } label: {
                                        Text( NSLocalizedString("fakeAccount", comment: "") )
                                    }
                                    
                                    Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }

                                })
                                
                                Divider()
                                
                                ActionSheetButtonHelper(icon: "block_icon",
                                                        label: NSLocalizedString("block", comment: ""),
                                                        role: .destructive) {
                                    self.showDialog.toggle()
//                                    cardAction = .report
                                    withAnimation(animation) {
                                        user.x = -1000; user.degree = -20
                                        checkLastAndRequestMore()
                                    }
                                    
//                                    userVM.blockUser(id: user.id)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    TextHelper(text: "\(user.name), \(user.age)", color: .white,
                               fontName: "Inter-SemiBold",
                               fontSize: 25)
                    
//                    HStack {
//
//                        TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
//                                       parentWidth: UIScreen.main.bounds.size.width * 0.55,
//                                       interests: user.interests.count <= 4 ?
//                                       user.interests : Array(user.interests.prefix(3)) +
//                                       [UserInterestModel(same: false, name: "+ \(NSLocalizedString("more", comment: "")) \(user.interests.count - 3)")])
//
//                        Button {
//                            navigate.toggle()
//                        } label: {
//                            Image(systemName: "info.circle")
//                                .foregroundColor(.white)
//                                .font(.title)
//                        }
//                    }
                    
                }.padding()
                
            }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.55)
            
            
            HStack( spacing: 15) {
                

                SwipeButtonHelper(icon: "broken_heart", color: .red, width: 20, height: 20, horizontalPadding: 15, verticalPadding: 15) {
                    // make request
                    cardAction = .dislike
                    withAnimation(animation) {
                        user.x = -1000; user.degree = -20
                        checkLastAndRequestMore()
                    }
                }
                
                SwipeButtonHelper(icon: "star", color: .blue, width: 20, height: 20, horizontalPadding: 15, verticalPadding: 15) {
                    // make request
                    cardAction = .star
                    withAnimation(animation) {
                        starredRotationDegree += 360
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            user.y = -1000;
                            checkLastAndRequestMore()
                        }
                    }
                }
                
                SwipeButtonHelper(icon: "heart", color: .red, width: 20, height: 20, horizontalPadding: 15, verticalPadding: 15) {
                    cardAction = .like
                    withAnimation(animation) {
                        user.x = 1000; user.degree = 20
                        checkLastAndRequestMore()
                    }
                }
            }
        }.padding(16)
            .background(
                Group {
                    switch cardAction {
                    case .like:
                        AppColors.onlineStatus
                    case .dislike:
                        Color.red
                    case .star:
                        Color.blue
                    case .none:
                        AppColors.light_purple
                    }
                }
            )
            .cornerRadius(30)
            .shadow(radius: 1)
            .offset(x: user.x, y: user.y)
            .rotationEffect(.init(degrees: user.degree))
            .rotation3DEffect(.degrees(starredRotationDegree), axis: (x: 0, y: 1, z: 0))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.default) {
                            user.x = value.translation.width
                            user.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            switch value.translation.width {
                            case 0...100:
                                cardAction = .none
                                user.x = 0
                                user.degree = 0
                            case let x where x > 100:
                                cardAction = .like
                                checkLastAndRequestMore()
                                user.x = 1000; user.degree = 20
//                                AppAnalytics().logEvent(event: "swipe")
                            case (-100)...(-1):
                                cardAction = .none
                                user.x = 0
                                user.degree = 0
                            case let x where x < -100:
                                cardAction = .dislike
                                checkLastAndRequestMore()
                                user.x = -1000; user.degree = -20
//                                AppAnalytics().logEvent(event: "swipe")
                            default:
                                cardAction = .none
                                user.x = 0;
                                user.degree = 0
                            }
                        }
                    })
            )
    }
    
    func checkLastAndRequestMore() {
//        if user.id == placesVM.users.first?.id {
//            placesVM.swipePage += 1
//            placesVM.getSwipes()
//        }
        // do smth
    }
    
    func reportUser() {
        withAnimation(animation) {
            user.x = -1000; user.degree = -20
            checkLastAndRequestMore()
        }
        
//        userVM.reportUser(id: user.id)
        self.showDialog.toggle()
    }
}

struct SwipeCard_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCard(user: AppPreviewModel.swipeModel)
    }
}
