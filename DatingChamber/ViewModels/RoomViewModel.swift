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
    
    @Published var messagesBlocks = [[MessageViewModel]]()
    @Published var messages = [MessageViewModel]()
    @Published var lastMessage: QueryDocumentSnapshot?
    
    @Published var lastMessageID: String = ""
    
    var manager: ChatServiceProtocol
    init(manager: ChatServiceProtocol = ChatService.shared) {
        self.manager = manager
    }
    
    @MainActor func sendMessage(messageType: MessageType,
                                duration: String? = nil,
                                firestoreManager: FirestorePaginatedFetchManager<[MessageModel], MessageModel, Timestamp>) {
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
            
            let result = await manager.sendMessage(manager: firestoreManager,
                                                   userID: userID,
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
}
