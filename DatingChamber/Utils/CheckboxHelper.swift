//
//  CheckboxHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 28.11.22.
//

import SwiftUI

struct CheckboxHelper: View {
    
    @Binding var toggler: Bool
    let message: String
    
    var body: some View {
        HStack {
            Button {
                toggler.toggle()
            } label: {
                ZStack {
                    Image("checkbox")
                    if toggler {
                        Image(systemName: "checkmark")
                            .foregroundColor(.gray)
                            .font(Font.system(size: 12, weight: .semibold))
                        
                    }
                }
            }
            
            TextHelper(text: message, fontSize: 12)
        }
    }
}

struct CheckboxHelper_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxHelper(toggler: .constant(false), message: NSLocalizedString("allowReading", comment: ""))
    }
}
