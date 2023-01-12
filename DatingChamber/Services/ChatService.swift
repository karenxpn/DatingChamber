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

protocol ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ())
    func sendMessage(userID: String, chatID: String, type: MessageType, media: Data?, text: String, duration: String?) async -> Result<Void, Error>
    func muteChat(userID: String, chatID: String, mute: Bool) async -> Result<Void, Error>
    func deleteChat(chatID: String) async -> Result<Void, Error>
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ())
    func fetchMessages(chatIID: String, lastMessage: QueryDocumentSnapshot?, completion: @escaping(Result<([MessageModel], QueryDocumentSnapshot?), Error>) -> ())
    
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    private init() { }
}

extension ChatService: ChatServiceProtocol {
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
        do {
            try await db.collection("Chats").document(chatID).updateData(["mutedBy" : mute ? FieldValue.arrayUnion([userID]) : FieldValue.arrayRemove([userID])])
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteChat(chatID: String) async -> Result<Void, Error> {
        do {
            try await db.collection("Chats").document(chatID).delete()
            return .success(())
        } catch {
            return .failure(error)
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
    
    func sendMessage(userID: String, chatID: String, type: MessageType, media: Data?, text: String, duration: String? ) async -> Result<Void, Error> {
        do {
            let user = try await db.collection("Users").document(userID).getDocument(as: UserModel.self)
            
            
            var url: String = ""
            var fileExtension = ""
            if type == .photo       { fileExtension = "jpg" }
            else if type == .video  { fileExtension = "mov" }
            else if type == .audio  { fileExtension = "m4a" }
            
            if type != .text {
                let dbRef = storageRef.child("chats/\(UUID().uuidString).\(fileExtension)")
                let _ = try await dbRef.putDataAsync(media!)
                url = try await dbRef.downloadURL().absoluteString
            }

            let message = MessageModel(createdAt: Timestamp(date: Date().toGlobalTime()),
                                       type: type,
                                       content: type == .text ? text : url,
                                       duration: duration,
                                       sentBy: userID,
                                       seenBy: [userID],
                                       isEdited: false,
                                       status: .sent,
                                       reactions: [])
            
            let lastMessage = LastMessageModel(lastMessage: message)
            
            let _ = try await db
                .collection("Chats")
                .document(chatID)
                .collection("messages")
                .addDocument(data: Firestore.Encoder().encode(message))
            
            let _ = try await db.collection("Chats").document(chatID).setData(from: lastMessage, merge: true)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
