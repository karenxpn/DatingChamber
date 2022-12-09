//
//  AppPreviewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
struct AppPreviewModel {
    static let swipeModel = SwipeUserViewModel(user: SwipeModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", avatar: Credentials.img_url, name: "Karen", birthday: .now, online: true, isVerified: false, interests: ["fuck", "you", "smth", "coffee", "tea", "chill", "travel"]), interests: ["tea", "coffee"])
    static let userModel = UserModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", name: "Karen", birthday: Date(), avatar: Credentials.img_url, bio: "Some bio here", images: [Credentials.img_url], interests: ["fuck", "you", "smth", "coffee", "tea", "chill", "travel"], gender: "Male", posts: [])
    static let posts = [PostViewModel(post: PostModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", title: "some title here", content: "lorem ipsumlorem ipsum, lorem ipsum, lorem ipsum, lorem ipsum, lorem ipsum lorem ipsum", image: Credentials.default_story_image, allowReading: false, readingVoice: nil, user: PostUserModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", name: "Karen", image: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92"))),
                                      PostViewModel(post: PostModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92sadf", title: "some title here", content: "lorem ipsumlorem ipsum, lorem ipsum, lorem ipsum, lorem ipsum, lorem ipsum lorem ipsum", image: Credentials.default_story_image, allowReading: true, readingVoice: "male", user: PostUserModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", name: "Karen", image: "asdfyo1NBb8aLlPbC1wJE5pdeJ4fZC92")))]
    
    static let chats = [ChatModelViewModel(
        chat: ChatModel(id: "asdfyo1NBb8aLlPbC1wJE5pdeJ4fZC92",
                        users: [UserPreviewModel(id: "a;sldkfj",
                                                 name: "Karen",
                                                 image: Credentials.img_url,
                                                 online: true, lastVisit: nil, blocked: false),
                                UserPreviewModel(id: "slkdjf",
                                                 name: "Martin",
                                                 image: Credentials.default_story_image,
                                                 online: true, lastVisit: nil, blocked: false)],
                        lastMessage: ChatMessagePreview(id: "1",
                                                         type: "text",
                                                         content: "Holaaa my name is Karen",
                                                         sentBy: "a;sldkfj",
                                                         seenBy: [""],
                                                         status: "sent",
                                                         createdAt: Date().toGlobalTime()), mutedBy: []))]
}

