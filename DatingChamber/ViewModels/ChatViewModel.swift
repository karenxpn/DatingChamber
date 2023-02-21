//
//  ChatViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class ChatViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var loadingPage: Bool = false
    
    @Published var chats = [ChatModelViewModel]()
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func getChats(refresh: Refresh? = nil) {
        if chats.isEmpty {
            loading = true
        }
        
        manager.fetchChats(userID: userID) { result in
            self.loading = false
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let chats):
                self.chats = chats.map(ChatModelViewModel.init)
            }
        }
    }
    
    @MainActor func muteChat(chatID: String, mute: Bool) {
        Task {
            let _ = await manager.muteChat(userID: userID, chatID: chatID, mute: mute)
        }
    }
    
    @MainActor func deleteChat(chatID: String) {
        Task {
            let _ = await manager.deleteChat(chatID: chatID)
        }
    }
}
