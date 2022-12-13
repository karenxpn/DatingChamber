//
//  ChatService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
import FirebaseFirestore
import AVFoundation
import SwiftUI

protocol ChatServiceProtocol {
    func fetchChats(lastChat: QueryDocumentSnapshot?, completion: @escaping(Result<([(ChatModel, DocumentChangeType)], QueryDocumentSnapshot?), Error>) -> ())
    func sendMessage(userID: String, chatID: String, text: String) async -> Result<Void, Error>
    func muteChat(userID: String, chatID: String, mute: Bool) async -> Result<Void, Error>
    func deleteChat(chatID: String) async -> Result<Void, Error>
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ())
    
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    let db = Firestore.firestore()
    
    private init() { }
}

extension ChatService: ChatServiceProtocol {
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
    
    func sendMessage(userID: String, chatID: String, text: String) async -> Result<Void, Error> {
        do {
            let user = try await db.collection("Users").document(userID).getDocument(as: UserModel.self)
            let _ = try await db.collection("Chats").document(chatID).setData(["lastMessage" : ["id": UUID().uuidString,
                                                                                                "content" : text,
                                                                                                "createdAt": Date().toGlobalTime(),
                                                                                                "sentBy": userID,
                                                                                                "seenBy": [userID],
                                                                                                "status": "sent",
                                                                                                "type": "text"]], merge: true)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
