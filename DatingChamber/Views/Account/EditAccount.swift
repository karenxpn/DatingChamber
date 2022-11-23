//
//  EditAccount.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 22.11.22.
//

import SwiftUI

struct EditAccount: View {
    @StateObject private var accountVM = AccountViewModel()
    
    var body: some View {
        ZStack {
            if accountVM.loading {
                ProgressView()
            } else if accountVM.user != nil {
                EditAccountInnerView()
            }
        }.task {
            accountVM.getAccount()
        }
    }
}

struct EditAccount_Previews: PreviewProvider {
    static var previews: some View {
        EditAccount()
    }
}
