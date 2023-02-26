//
//  SwipeCard.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI


struct SwipeCard: View {
    @EnvironmentObject var swipesVM: SwipesViewModel
    @StateObject var userVM = UserViewModel()
    @State var user: SwipeUserViewModel
    @State private var navigate: Bool = false
    @State private var showDialog: Bool = false
    @State private var showReportConfirmation: Bool = false
    @State private var starredRotationDegree: Double = 360
    @State private var cardAction: CardAction? = .none
    
    @State private var blur: CGFloat = 0
    
    
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
                    .blur(radius: blur)
                    .overlay(
                        Group {
                            if cardAction == .dislike {
                                Image( "swipe_broken_heart" )
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame( width: 80, height: 80)
                                    .padding()
                                    .opacity(cardAction == .dislike ? 1 : 0)
                            } else if cardAction == .like {
                                Image( "swipe_heart" )
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame( width: 80, height: 80)
                                    .padding()
                                    .opacity(cardAction == .like ? 1 : 0)
                                
                            }
                        })
                
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
                            SwipeCardActionSheet(showDialog: $showDialog, showReportConfirmation: $showReportConfirmation, reportReason: $userVM.reportReason, user: $user, cardAction: $cardAction, animation: animation) {
                                reportUser()
                            } checkLastAndRequestMore: {
                                checkLastAndRequestMore()
                            }.environmentObject(userVM)
                        }
                    }
                    
                    Spacer()
                    TextHelper(text: "\(user.name), \(user.age)", color: .white,
                               fontName: "Inter-SemiBold",
                               fontSize: 25)
                    
                    HStack {
                        
                        TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                                       parentWidth: UIScreen.main.bounds.size.width * 0.7,
                                       interests: user.interests.count <= 4 ?
                                       user.interests : Array(user.interests.prefix(3)) +
                                       [InterestModel(same: false, name: "+ \(NSLocalizedString("more", comment: "")) \(user.interests.count - 3)")])
                        
                        Button {
                            navigate.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                    
                }.padding()
                
            }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.55)
            
            
            HStack( spacing: 15) {
                
                SwipeButtonHelper(icon: "refresh", color: .white, width: 20, height: 20, horizontalPadding: 15, verticalPadding: 15, background: .clear) {
                    swipesVM.lastUser = nil
                    swipesVM.getUsers()
                }
                
                
                SwipeButtonHelper(icon: "broken_heart", color: AppColors.red, width: 28, height: 28, horizontalPadding: 15, verticalPadding: 15) {
                    // make request
                    cardAction = .dislike
                    userVM.dislikeUser(uid: user.id)
                    withAnimation(animation) {
                        user.x = -1000; user.degree = -20
                        checkLastAndRequestMore()
                    }
                }
                
                SwipeButtonHelper(icon: "heart", color: AppColors.red, width: 28, height: 28, horizontalPadding: 15, verticalPadding: 15) {
                    cardAction = .like
                    userVM.likeUser(uid: user.id)
                    withAnimation(animation) {
                        user.x = 1000; user.degree = 20
                        checkLastAndRequestMore()
                    }
                }
                
                SwipeButtonHelper(icon: "star", color: .white, width: 20, height: 20, horizontalPadding: 15, verticalPadding: 15, background: .clear) {
                    // make request
                    
                    cardAction = .star
                    withAnimation {
                        user.y = -1000;
                        checkLastAndRequestMore()
                    }
                }
            }
        }.padding(16)
            .background(
                Group {
                    if cardAction == .report    { Color.red }
                    else                        { AppColors.light_orange }
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
                            blur += 0.1
                            
                            if user.x > 30          { cardAction = .like }
                            else if user.x < -30    { cardAction = .dislike }
                            else                    { cardAction = .none }
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            switch value.translation.width {
                            case 0...100:
                                cardAction = .none
                                user.x = 0
                                user.degree = 0
                                blur = 0
                            case let x where x > 100:
                                cardAction = .like
                                userVM.likeUser(uid: user.id)
                                checkLastAndRequestMore()
                                user.x = 1000; user.degree = 20
                            case (-100)...(-1):
                                cardAction = .none
                                user.x = 0
                                user.degree = 0
                                blur = 0
                            case let x where x < -100:
                                cardAction = .dislike
                                userVM.likeUser(uid: user.id)
                                checkLastAndRequestMore()
                                user.x = -1000; user.degree = -20
                            default:
                                cardAction = .none
                                user.x = 0;
                                user.degree = 0
                                blur = 0
                            }
                        }
                    })
            ).alert(isPresented: $userVM.showAlert) {
                Alert(title: Text(NSLocalizedString("error", comment: "")),
                      message: Text(userVM.alertMessage),
                      dismissButton: .default(Text(NSLocalizedString("gotIt", comment: ""))))
            }
    }
    
    func checkLastAndRequestMore() {
        if user.id == swipesVM.users.first?.id {
            swipesVM.getUsers()
        }
    }
    
    func reportUser() {
        userVM.reportUser(uid: user.id)
        cardAction = .report
        withAnimation {
            user.y = 1000;
            checkLastAndRequestMore()
        }
        
        self.showDialog.toggle()
    }
}

struct SwipeCard_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCard(user: AppPreviewModel.swipeModel)
            .environmentObject(SwipesViewModel())
    }
}
