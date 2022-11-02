//
//  AuthViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import Foundation
class AuthViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var country: String = "US"
    @Published var code: String = "1"
    @Published var phoneNumber: String = ""
    
    @Published var agreement: Bool = false
    
    
}
