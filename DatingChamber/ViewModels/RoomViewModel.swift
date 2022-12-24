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
                
                for message in response.0 {
                    if message.1 == .added          { self.messages.append(MessageViewModel(message: message.0)) }
                    else if message.1 == .removed   { self.messages.removeAll(where: {$0.id == message.0.id}) }
                    else if message.1 == .modified {
                        if let index = self.messages.firstIndex(where: {$0.id == message.0.id }) {
                            self.messages[index] = MessageViewModel(message: message.0)
                        }
                    }
                }
                
                if !response.0.isEmpty {
                    self.lastMessage = response.1
                    self.lastMessageID = self.messages[0].id
                }
                
            }
        })
    }
}
