//
//  ChatService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestore
import AVFoundation
import FirebaseStorage
import SwiftUI
import FirebaseService

protocol ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ())
    func sendMessage(userID: String,
                     chatID: String,
                     type: MessageType,
                     content: String,
                     repliedTo: RepliedMessageModel?,
                     duration: String?) async -> Result<Void, Error>
    
    func muteChat(userID: String, chatID: String, mute: Bool) async -> Result<Void, Error>
    func deleteChat(chatID: String) async -> Result<Void, Error>
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ())
    func uploadMedia(media: Data, type: MessageType) async -> Result<String, Error>
    func editMessage(chatID: String, messageID: String, message: String, status: MessageStatus) async -> Result<Void, Error>
    func sendReaction(chatID: String, messageID: String, reaction: ReactionModel, action: ReactionAction) async -> Result<Void, Error>
    func fetchMessages(chatIID: String, lastMessage: QueryDocumentSnapshot?, completion: @escaping(Result<([MessageModel], QueryDocumentSnapshot?), Error>) -> ())
    func markMessageAsRead(chatID: String, messageID: String, userID: String) async -> Result<Void, Error>

}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    private init() { }
}

extension ChatService: ChatServiceProtocol {
    
    func markMessageAsRead(chatID: String, messageID: String, userID: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest(action: {
            try await db.collection("Chats")
                .document(chatID)
                .collection("messages")
                .document(messageID)
                .updateData(["seenBy" : FieldValue.arrayUnion([userID])])
        })
    }
    
    func fetchMessages(chatIID: String, lastMessage: QueryDocumentSnapshot?, completion: @escaping (Result<([MessageModel], QueryDocumentSnapshot?), Error>) -> ()) {
        var query: Query = db.collection("Chats")
            .document(chatIID)
            .collection("messages")
            .order(by: "createdAt", descending: true)
        
        if lastMessage == nil {
            let currentQuery = query.limit(to: 5)
                currentQuery.getDocuments { snapshot, error in
                    if let error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }
                    
                    let last = snapshot!.documents.last
                    if let last { query = query.end(atDocument: last) }
                    
                    query.addSnapshotListener { snapshot, error in
                        if let error {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
                        }
                        
                        guard snapshot?.documents.last != nil else {
                            DispatchQueue.main.async {
                                completion(.success(([], nil)))
                            }
                            // The collection is empty.
                            return
                        }
                        
                        var results = [(MessageModel)]()
                        snapshot?.documents.forEach({ doc in
                            do {
                                let message = try doc.data(as: MessageModel.self)
                                results.append(message)
                            } catch {
                                print(error)
                            }
                        })
                        
                        DispatchQueue.main.async {
                            completion(.success((results, snapshot?.documents.last)))
                        }
                    }
                    
                }

        } else {
            query = query.start(afterDocument: lastMessage!).limit(to: 5)
            query.addSnapshotListener { snapshot, error in
                if let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard snapshot?.documents.last != nil else {
                    DispatchQueue.main.async {
                        completion(.success(([], nil)))
                    }
                    // The collection is empty.
                    return
                }
                
                var results = [(MessageModel)]()
                
                snapshot?.documents.forEach({ doc in
                    do {
                        let message = try doc.data(as: MessageModel.self)
                        results.append(message)
                    } catch {
                        print(error)
                    }
                })
                
                DispatchQueue.main.async {
                    completion(.success((results, snapshot?.documents.last)))
                }
            }
        }
    }
    
    
    func sendReaction(chatID: String, messageID: String, reaction: ReactionModel, action: ReactionAction) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("Chats")
                .document(chatID)
                .collection("messages")
                .document(messageID)
                .updateData(["reactions": action == .react ?
                             FieldValue.arrayUnion([["userId" : reaction.userId,
                                                     "reaction" : reaction.reaction]]) :
                                FieldValue.arrayRemove([["userId": reaction.userId,
                                                         "reaction": reaction.reaction]])])
        }
    }

    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                var cur_url = url
                if url.absoluteString.hasPrefix("https://") {
                    let data = try Data(contentsOf: url)
                    
                    let directory = FileManager.default.temporaryDirectory
                    let fileName = "chunk.m4a"
                    cur_url = directory.appendingPathComponent(fileName)
                    
                    try data.write(to: cur_url)
                }
                
                let file = try AVAudioFile(forReading: cur_url)
                if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                              sampleRate: file.fileFormat.sampleRate,
                                              channels: file.fileFormat.channelCount, interleaved: false),
                   let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) {
                    
                    try file.read(into: buf)
                    guard let floatChannelData = buf.floatChannelData else { return }
                    let frameLength = Int(buf.frameLength)
                    
                    let samples = Array(UnsafeBufferPointer(start:floatChannelData[0], count:frameLength))
                    
                    var result = [AudioPreviewModel]()
                    
                    let chunked = samples.chunked(into: samples.count / samplesCount)
                    for row in chunked {
                        var accumulator: Float = 0
                        let newRow = row.map{ $0 * $0 }
                        accumulator = newRow.reduce(0, +)
                        let power: Float = accumulator / Float(row.count)
                        let decibles = 10 * log10f(power)
                        
                        result.append(AudioPreviewModel(magnitude: decibles, color: Color.gray))
                        
                    }
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            } catch {
                print("Audio Error: \(error)")
            }
        }
        
    }
    func muteChat(userID: String, chatID: String, mute: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("Chats").document(chatID).updateData(["mutedBy" : mute ? FieldValue.arrayUnion([userID]) : FieldValue.arrayRemove([userID])])
        }
    }
    
    func deleteChat(chatID: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("Chats").document(chatID).delete()
        }
    }
    
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ()){
        // modify this lastMesssage -> lastMessage
        var query: Query = db.collection("Chats").order(by: "lastMessage.createdAt", descending: true)
        if lastChat == nil   { query = query.limit(to: 10) }
        else                 { query = query.start(afterDocument: lastChat!).limit(to: 10) }
        
        query.addSnapshotListener { snapshot, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard snapshot?.documents.last != nil else {
                DispatchQueue.main.async {
                    completion(.success(([], nil)))
                }
                // The collection is empty.
                return
            }
            
            var results = [(ChatModel, DocumentChangeType)]()
            
            snapshot?.documentChanges.forEach({ diff in
                do {
                    let doc = try diff.document.data(as: ChatModel.self)
                    results.append((doc, diff.type))
                } catch {
                    print(error)
                }
                
            })
            
            DispatchQueue.main.async {
                completion(.success((results, snapshot?.documents.last)))
            }
        }
    }
    
    func uploadMedia(media: Data, type: MessageType) async -> Result<String, Error> {
        do {
            var fileExtension = ""
            if type == .photo       { fileExtension = "jpg" }
            else if type == .video  { fileExtension = "mov" }
            else if type == .audio  { fileExtension = "m4a" }
            
            let dbRef = storageRef.child("chats/\(UUID().uuidString).\(fileExtension)")
            let _ = try await dbRef.putDataAsync(media)
            let url = try await dbRef.downloadURL().absoluteString
            
            return .success(url)
        } catch {
            return .failure(error)
        }
    }
    
    func sendMessage(userID: String,
                     chatID: String,
                     type: MessageType,
                     content: String,
                     repliedTo: RepliedMessageModel?,
                     duration: String?) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            let user = try await db.collection("Users").document(userID).getDocument(as: UserModel.self)

            let message = MessageModel(createdAt: Timestamp(date: Date().toGlobalTime()),
                                       type: type,
                                       content: content,
                                       duration: duration,
                                       sentBy: userID,
                                       seenBy: [userID],
                                       isEdited: false,
                                       status: .sent,
                                       repliedTo: repliedTo,
                                       reactions: [],
                                       senderName: user.name)
                        
            let sentMessage = try await db
                .collection("Chats")
                .document(chatID)
                .collection("messages")
                .addDocument(data: Firestore.Encoder().encode(message))
            
            let curMessage = try await sentMessage.getDocument(as: MessageModel.self)
            let lastMessage = LastMessageModel(id: curMessage.id,
                                                    createdAt: curMessage.createdAt,
                                                    type: curMessage.type,
                                                    content: curMessage.content,
                                                    sentBy: curMessage.sentBy,
                                                    seenBy: curMessage.seenBy,
                                                    status: curMessage.status)
            
            print(lastMessage)
            
            let _ = try await db.collection("Chats").document(chatID).updateData(["lastMessage": Firestore.Encoder().encode(lastMessage)])
        }
    }
    
    func editMessage(chatID: String, messageID: String, message: String, status: MessageStatus) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            let _ = try await db.collection("Chats").document(chatID).collection("messages").document(messageID)
                .setData(["content" : message,
                          "isEdited": true,
                          "status": status.rawValue,
                          "type": MessageType.text.rawValue], merge: true)
        }
    }
}
