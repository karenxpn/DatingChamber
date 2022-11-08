//
//  SwipesViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import Foundation
class SwipesViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var users = [AppPreviewModel.swipeModel]
}
