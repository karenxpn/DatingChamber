//
//  TabViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
import SwiftUI

class TabViewModel: ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var currentTab: Int = 0
    @Published var hasUnreadMessage: Bool = false

}
