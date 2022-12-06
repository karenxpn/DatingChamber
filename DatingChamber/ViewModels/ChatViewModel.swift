//
//  ChatViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var chats = [ChatModelViewModel]()
    @Published var lastChat: QueryDocumentSnapshot?
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func getChats() {
        loading = true
        Task {
            let result = await manager.fetchChats(lastChat: lastChat)
            switch result {
            case .success(let chats):
                self.chats.append(contentsOf: chats.map(ChatModelViewModel.init))
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
