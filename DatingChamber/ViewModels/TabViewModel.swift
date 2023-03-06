//
//  TabViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
import SwiftUI

class TabViewModel: ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var currentTab: Int = 0
    @Published var hasUnreadMessage: Bool = false
    
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserService.shared) {
        self.manager = manager
    }
    
    @MainActor func updateOnlineStatus(online: Bool, lastVisit: Date?) {
        Task {
            if !userID.isEmpty {
                let _ = await manager.updateOnlineState(userID: userID, online: online, lastVisit: lastVisit)
            }
        }
    }
}
