//
//  RoomViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class RoomViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    
    @Published var chatID: String = ""
    @Published var message: String = ""
    @Published var editingMessage: MessageViewModel?
    @Published var replyMessage: MessageViewModel?
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var messagesBlocks = [[MessageViewModel]]()
    @Published var messages = [MessageViewModel]()
    @Published var lastMessage: QueryDocumentSnapshot?
    
    @Published var lastMessageID: String = ""
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func sendMessage() {
        Task {
            let result = await manager.sendMessage(userID: userID, chatID: chatID, text: message)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                self.message = ""
            }
        }
    }
    
    
    func getMessages() {
        loading = true
        
        manager.fetchMessages(chatIID: chatID, lastMessage: lastMessage, completion: { result in
            self.loading = false
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                // response.0 -> messages
                // response.1 -> last message
                
                print(response.0.count)
                if response.0.count > 5 {
                    self.messagesBlocks[0].insert(MessageViewModel(message: response.0[0]), at: 0)
                    print(self.messagesBlocks[0])
                    withAnimation {
                        self.messages.insert(MessageViewModel(message: response.0[0]), at: 0)
                    }
                    
                    if !response.0.isEmpty {
                        self.lastMessageID = self.messages[0].id
                    }
                } else {
                    self.messagesBlocks.append(response.0.map(MessageViewModel.init))
                    self.messages = Array(self.messagesBlocks.joined())
                    
                    if !response.0.isEmpty {
                        self.lastMessageID = self.messages[0].id
                        self.lastMessage = response.1
                    }
                }
            }
        })
    }
}
