//
//  BlogService.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import Foundation
import Combine

protocol BlogServiceProtocol {
    func fetchPosts() async -> Result<[PostModel], Error>
}

class BlogService {
    static let shared: BlogServiceProtocol = BlogService()
    private init() { }
}

extension BlogService: BlogServiceProtocol {
    func fetchPosts() async -> Result<[PostModel], Error> {
        return .success([])
    }
}
