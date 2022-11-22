//
//  AppPreviewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
struct AppPreviewModel {
    static let swipeModel = SwipeUserViewModel(user: SwipeModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", avatar: Credentials.img_url, name: "Karen", birthday: .now, online: true, isVerified: false, interests: ["fuck", "you", "smth", "coffee", "tea", "chill", "travel"]), interests: ["tea", "coffee"])
    static let userModel = UserModel(id: "yo1NBb8aLlPbC1wJE5pdeJ4fZC92", name: "Karen", birthday: Date(), avatar: Credentials.img_url, bio: "Some bio here", images: [Credentials.img_url], interests: ["fuck", "you", "smth", "coffee", "tea", "chill", "travel"])
}

