//
//  SwipesViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
import SwiftUI

class SwipesViewModel: AlertViewModel, ObservableObject {
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
    
    
    @Published var users = [AppPreviewModel.swipeModel]
    
    override init() {
        super.init()
        
        self.ageRange = self.ageLowerBound...self.ageUppwerBound
        self.gender = self.preferredGender
        self.status = self.usersStatus
    }
    
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
            // get swipes agait
        }
    }
    
}
