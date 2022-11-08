//
//  Swipes.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

struct Swipes: View {
    @StateObject var swipesVM = SwipesViewModel()
    
    var body: some View {
        if swipesVM.loading {
            ProgressView()
        } else {
            ZStack {
                ForEach(swipesVM.users, id: \.id) { user in
                    SwipeCard(user: user)
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
