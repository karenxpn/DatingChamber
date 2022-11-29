//
//  UserModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import Foundation
struct UserModel: Identifiable, Codable {
    var id: String
    var name: String
    var birthday: Date
    var avatar: String
    var bio: String?
    var images: [String]
    var interests: [String]
    var gender: String
    var occupation: String?
    var city: String?
    var education: String?
    var posts: [PostModel]?
}

struct UserModelViewModel: Identifiable {
    var user: UserModel
    init(user: UserModel) {
        self.user = user
    }
    
    var id: String  { self.user.id }
    var name: String {
        get { self.user.name }
        set { self.user.name = newValue }
    }
    
    var birthday: Date {
        get { self.user.birthday }
        set { self.user.birthday = newValue }
    }
    
    var stringBirthday: String {
        self.user.birthday.formatted(date: .abbreviated, time: .omitted)
    }
    
    var age: String         { self.user.birthday.getAgeFromBirthDate()}
    
    var avatar: String {
        get { self.user.avatar }
        set { self.user.avatar = newValue }
    }
    
    var bio: String {
        get { self.user.bio ?? "" }
        set { self.user.bio = newValue }
    }
    
    var images: [String] {
        get { self.user.images }
        set { self.user.images = newValue }
        
    }
    
    var interests: [String] {
        get { self.user.interests }
        set { self.user.interests = newValue }
    }

    var gender: String {
        get { self.user.gender }
        set { self.user.gender = newValue }
        
    }
    
    var education: String {
        get { self.user.education ?? "" }
        set { self.user.education = newValue }
    }

    var occupation: String {
        get { self.user.occupation ?? "" }
        set { self.user.occupation = newValue }
    }
    
    var city: String {
        get { self.user.city ?? "" }
        set { self.user.city = newValue }
    }
    
    var posts: [PostModel] {
        get { self.user.posts ?? []}
        set { self.user.posts = newValue }
    }
}
