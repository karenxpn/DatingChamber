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
        
        manager.fetchChats(lastChat: lastChat) { result in
            self.loadingPage = false
            self.loading = false
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let chats):   // ([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?)
                // map the result and check type of difference
                if refresh == .refresh  { self.chats = chats.0.map{ChatModelViewModel(chat: $0.0)} }
                else {
                    for chat in chats.0 {
                        if chat.1 == .removed       { self.chats.removeAll(where: { $0.id == chat.0.id }) }
                        else if chat.1 == .added    { self.chats.append(ChatModelViewModel(chat: chat.0)) }
                        else if chat.1 == .modified {
                            if let index = self.chats.firstIndex(where: { $0.id == chat.0.id }) {
                                self.chats[index] = ChatModelViewModel(chat: chat.0)
                                // update list here move to front if chat id is different
                                
                            }
                        }
                    }
                }
                
                if !chats.0.isEmpty {
                    self.lastChat = chats.1
                }
            }
        }
    }
}
