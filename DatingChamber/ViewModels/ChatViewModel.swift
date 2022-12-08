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
    
    @Published var loadingPage: Bool = false
    
    @Published var chats = [ChatModelViewModel]()
    @Published var lastChat: QueryDocumentSnapshot?
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func getChats(refresh: Refresh? = nil) {
        if refresh == .refresh {
            lastChat = nil
        }
        
        if chats.isEmpty {
            loading = true
        } else {
            loadingPage = true
        }
        Task {
            let result = await manager.fetchChats(lastChat: lastChat)
            switch result {
            case .success(let chats):
                if refresh == .refresh  { self.chats = chats.map(ChatModelViewModel.init) }
                else                    { self.chats.append(contentsOf: chats.map(ChatModelViewModel.init)) }
                
                // store last chat here
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loadingPage = false
                loading = false
            }
        }
    }
}
