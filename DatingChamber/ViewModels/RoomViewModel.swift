//
//  RoomViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseService

class RoomViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    
    @Published var chatID: String = ""
    @Published var message: String = ""
    @Published var media: Data?
    @Published var editingMessage: MessageViewModel?
    @Published var replyMessage: MessageViewModel?
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var messagesBlocks: [String: [MessageViewModel]] = [:]
    @Published var messages = [MessageViewModel]()
    @Published var lastMessage: QueryDocumentSnapshot?
    
    @Published var lastMessageID: String = ""
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func sendMessage(messageType: MessageType,
                                duration: String? = nil) {
        if messageType == .audio {
            NotificationCenter.default.post(name: Notification.Name("hide_audio_preview"), object: nil)
        }
        
        Task {
            if let media = media{
                if  messageType != .text  {
                    let mediaUploadResult = await manager.uploadMedia(media: media, type: messageType)
                    switch mediaUploadResult {
                    case .failure(let error):
                        self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                    case .success(let url):
                        // send message
                        self.message = url
                    }
                }
            }
            
            let replyTo = replyMessage != nil ? RepliedMessageModel(name: replyMessage!.senderName,
                                                                    message: replyMessage!.content,
                                                                    type: replyMessage!.type) : nil
            
            let result = await manager.sendMessage(userID: userID,
                                                   chatID: chatID,
                                                   type: messageType,
                                                   content: message,
                                                   repliedTo: replyTo,
                                                   duration: duration)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                self.message = ""
                self.replyMessage = nil
            }
        }
    }
    
    @MainActor func editMessage() {
        Task {
            let result = await manager.editMessage(chatID: chatID,
                                                   messageID: editingMessage?.id ?? UUID().uuidString,
                                                   message: message,
                                                   status: .sent)
            switch result {
            case .success(()):
                self.message = ""
                self.editingMessage = nil
            case .failure(_):
                break
            }
        }
    }
    
    @MainActor func deleteMessage(messageID: String) {
        Task {
            let _ = await manager.editMessage(chatID: chatID,
                                              messageID: messageID,
                                              message: "This message was deleted",
                                              status: .deleted)
        }
    }
    
    @MainActor func sendReaction(message: MessageViewModel, reaction: String) {
        Task {
            var action = ReactionAction.react
            let reaction = ReactionModel(userId: userID, reaction: reaction)
            if message.reactionModels.contains(where: { $0 == reaction}) {
                action = .remove
            }
            
            let _ = await manager.sendReaction(chatID: chatID,
                                               messageID: message.id,
                                               reaction: reaction,
                                               action: action)
        }
    }
    
    func getMessages() {
        loading = true
        
        manager.fetchMessages(chatIID: chatID, lastMessage: lastMessage, completion: { result in
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                // response.0 -> messages
                // response.1 -> last message
                
                if let snapshot = response.1 {
                    self.messagesBlocks[snapshot.documentID] = response.0.map(MessageViewModel.init)
                    self.messages = self.messagesBlocks.flatMap{ $0.value }.sorted(by: { $0.creationDate > $1.creationDate})
                    self.lastMessage = snapshot
                }
            }
            
            self.loading = false

        })
    }
}
