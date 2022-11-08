//
//  AlertViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 02.11.22.
//

import Foundation
import Foundation
import SwiftUI

class AlertViewModel {
    
    func makeAlert(with error: Error, message: inout String, alert: inout Bool ) {
        message = error.localizedDescription
        alert.toggle()
    }
}
