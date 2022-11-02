//
//  Introduction.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.11.22.
//

import SwiftUI

struct Introduction: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: Authentication()) {
                    Text("Some introduction here click to move to authentication")
                }
                .navigationTitle("Introduction")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()
    }
}
