//
//  BlockedUsers.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.12.22.
//

import SwiftUI

struct BlockedUsers: View {
    @StateObject var accountVM = AccountViewModel()
    
    var body: some View {
        
        ZStack {
            if accountVM.loading {
                ProgressView()
            } else {
                List {
                    ForEach(accountVM.blockedUsers, id: \.id) { user in
                        BlockedListCell(user: user)
                            .listRowInsets(EdgeInsets())

                    }
                    
                    if accountVM.loadingPage {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    
                    Spacer()
                        .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                        .listRowSeparator(.hidden)
                }.listStyle(.plain)
                    .padding(.top, 1)
                    .refreshable {
                        accountVM.getBlockedUsers(refresh: .refresh)
                    }
                    
            }
        }.task {
            accountVM.getBlockedUsers()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                TextHelper(text: NSLocalizedString("blockedUsers", comment: ""),
                           fontName: "Inter-Black",
                           fontSize: 24)
                .kerning(0.56)
                .padding(.bottom, 10)
                .accessibilityAddTraits(.isHeader)
            }
        }.navigationTitle(Text(""))
    }
}

struct BlockedUsers_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUsers()
    }
}
