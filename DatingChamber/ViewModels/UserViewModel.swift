//
//  UserViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.11.22.
//

import Foundation
class UserViewModel: AlertViewModel, ObservableObject {
    @Published var reportReason: String = ""
    
    var manager: UserServiceProtocol
    
    init(manager: UserServiceProtocol = UserService.shared) {
        self.manager = manager
    }
}
