//
//  RoomViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.12.22.
//

import Foundation
import SwiftUI

class RoomViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""    
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func sendMessage(text: String, chat: String) {
        Task {
            let result = await manager.sendMessage(userID: userID, chatID: chat, text: text)
        }
    }
}
