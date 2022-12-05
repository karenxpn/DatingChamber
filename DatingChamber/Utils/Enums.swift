//
//  Enums.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.12.22.
//

import Foundation
enum Refresh {
    case refresh
}

enum CardAction {
    case dislike, like, star, report
}

enum BirthdayForm: Hashable {
    case day
    case month
    case year
}
