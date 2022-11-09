//
//  Swipes.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

struct Swipes: View {
    @StateObject var swipesVM = SwipesViewModel()
    @State private var showFilter: Bool = false
    @State private var offsetOnDrag: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if swipesVM.loading {
                    ProgressView()
                } else {
                    ZStack {
                        ForEach(swipesVM.users, id: \.id) { user in
                            SwipeCard(user: user)
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 30)
                }
                Filter(present: $showFilter, gender: $swipesVM.gender, status: $swipesVM.status, range: $swipesVM.ageRange)
                    .offset(y: showFilter ?  -UIScreen.main.bounds.size.height/4: -UIScreen.main.bounds.size.height)
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 50, initialVelocity: 0), value: showFilter)
                    .offset(y: offsetOnDrag)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            if value.translation.height < 0 {
                                self.offsetOnDrag = value.translation.height
                            }
                        }).onEnded({ (value) in
                            if value.translation.height < 0 {
                                self.showFilter = false
                                self.offsetOnDrag = 0
                            }
                        }))
            }.task {
                swipesVM.getUsers()
            }.alert(isPresented: $swipesVM.showAlert) {
                Alert(title: Text(NSLocalizedString("error", comment: "")),
                      message: Text(swipesVM.alertMessage),
                      dismissButton: .default(Text(NSLocalizedString("gotIt", comment: ""))))
            }
            .navigationBarItems(leading: TextHelper(text: "Dating Chamber",
                                                     fontName: "Inter-Bold",
                                                     fontSize: 28).kerning(0.56), trailing: Button {
                showFilter.toggle()
            } label: {
                Image("icon_filter")
                    .foregroundColor(showFilter ? AppColors.primary : .black)
            }).onChange(of: showFilter) { value in
                if !value {
                    swipesVM.storeFilterValues()
                }
            }
        }
    }
}

struct Swipes_Previews: PreviewProvider {
    static var previews: some View {
        Swipes()
    }
}
