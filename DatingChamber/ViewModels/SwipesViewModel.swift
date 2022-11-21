//
//  SwipesViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
import Firebase
import SwiftUI

class SwipesViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    @AppStorage( "ageLowerBound" ) var ageLowerBound: Int = 18
    @AppStorage( "ageUpperBound" ) var ageUppwerBound: Int = 51
    @AppStorage( "preferredGender" ) var preferredGender: String = NSLocalizedString("all", comment: "")
    @AppStorage( "usersStatus" ) var usersStatus: String = NSLocalizedString("all", comment: "")
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var ageRange: ClosedRange<Int> = 18...51
    @Published var gender: String = ""
    @Published var status: String = ""
    
    @Published var lastUser: QueryDocumentSnapshot?
    
    
    @Published var users = [SwipeUserViewModel]()
    @Published var myInterests = [String]()
    
    var manager: SwipesServiceProtocol
    init(manager: SwipesServiceProtocol = SwipesService.shared) {
        self.manager = manager
        super.init()
        
        self.ageRange = self.ageLowerBound...self.ageUppwerBound
        self.gender = self.preferredGender
        self.status = self.usersStatus
    }
    
    @MainActor
    func storeFilterValues() {
        var mark = false
        if ageLowerBound != ageRange.lowerBound ||
            ageUppwerBound != ageRange.upperBound ||
            preferredGender != gender ||
            usersStatus != status {
            mark = true
        }
        
        ageLowerBound = ageRange.lowerBound
        ageUppwerBound = ageRange.upperBound
        preferredGender = gender
        usersStatus = status
        
        if mark {
            getUsers()
        }
    }
    
    @MainActor
    func getUsers() {
        loading = true
        Task {
            let result = await manager.fetchSwipes(userID: userID,
                                                   gender: preferredGender,
                                                   minAge: ageLowerBound,
                                                   maxAge: ageUppwerBound,
                                                   online: usersStatus,
            lastDocSnapshot: lastUser)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let users):
                self.users = users.0.0.map{SwipeUserViewModel.init(user: $0, interests: users.0.1)}
                self.myInterests = users.0.1
                self.lastUser = users.1
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
}
