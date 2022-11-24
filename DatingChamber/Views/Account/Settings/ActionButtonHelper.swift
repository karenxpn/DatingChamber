//
//  ActionButtonHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import SwiftUI

struct ActionButtonHelper: View {
    
    let label: String
    let action: (() -> Void)
    
    var body: some View {
        
        Button(action: action) {
            SettingsButtonHelperContent(label: label)
        }
    }
}

struct ActionButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonHelper(label: "Privacy_Policy", action: {
            if let url = URL(string: "https://www.google.com") {
                   UIApplication.shared.open(url)
                }
        })
    }
}
