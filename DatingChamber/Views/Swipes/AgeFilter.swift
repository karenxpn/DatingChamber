//
//  AgeFilter.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 08.11.22.
//

import SwiftUI

import SwiftUI
import Sliders

struct AgeFilter: View {
        
    @Binding var range: ClosedRange<Int>
    
    var body: some View {
        VStack( alignment: .leading, spacing: 10 ) {
            
            VStack( alignment: .leading, spacing: 0) {
                TextHelper(text: NSLocalizedString("age", comment: ""),
                           fontName: "Inter-SemiBold",
                           fontSize: 18)
                
                HStack {
                    Spacer()
                    TextHelper(text: "\(range.lowerBound) - \(range.upperBound)",
                               color: AppColors.filterGray,
                               fontSize: 12)
                }
            }
            
            
            RangeSlider(range: $range,
                        in: 18...51)
                .rangeSliderStyle(
                        HorizontalRangeSliderStyle(
                            track:
                                HorizontalRangeTrack(
                                    view: Capsule().foregroundColor(AppColors.primary)
                                )
                                .background(Capsule().foregroundColor(AppColors.primary.opacity(0.25)))
                                .frame(height: 3),
                            lowerThumb: Circle().foregroundColor(AppColors.primary),
                            upperThumb: Circle().foregroundColor(AppColors.primary),
                            lowerThumbSize: CGSize(width: 12, height: 12),
                            upperThumbSize: CGSize(width: 12, height: 12),
                            options: .forceAdjacentValue
                        )
                ).frame(height: 20)
            
            HStack {
                TextHelper(text: "18", color: AppColors.filterGray, fontSize: 12)
                Spacer()
                TextHelper(text: "50+", color: AppColors.filterGray, fontSize: 12)
            }
        }
    }
}

struct AgeFilter_Previews: PreviewProvider {
    static var previews: some View {
        AgeFilter(range: .constant(1...51))
    }
}
