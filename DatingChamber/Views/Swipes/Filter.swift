//
//  Filter.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//
import SwiftUI
import Sliders

struct Filter: View {
    let genders = [NSLocalizedString("male", comment: ""),
                   NSLocalizedString("female", comment: ""),
                   NSLocalizedString("all", comment: "")]
    
    let statuses = [NSLocalizedString("online", comment: ""),
                    NSLocalizedString("all", comment: "")]
    
    @Binding var present: Bool
    @Binding var gender: String
    @Binding var status: String
    @Binding var range: ClosedRange<Int>
    
    var body: some View {
        VStack( alignment: .leading, spacing: 20) {
            
            Spacer()
            
            CustomSegmentPicker(selection: $gender, variants: genders, header: NSLocalizedString("showGenders", comment: ""))
            
            AgeFilter(range: $range)
            
            CustomSegmentPicker(selection: $status, variants: statuses, header: NSLocalizedString("showOnline", comment: ""))
            
            Button {
                present.toggle()
            } label: {
                HStack {
                    Spacer()
                    Image("filter-rectangle")
                    Spacer()
                }
            }.padding(.top, 30)
            
        }.padding(20)
            .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 450)
            .background(.white)
            .cornerRadius(35)
            .shadow(radius: 5, x: 0, y: 10)
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        Filter(present: .constant(true), gender: .constant("Male"), status: .constant("Online"), range: .constant(1...51))
    }
}
