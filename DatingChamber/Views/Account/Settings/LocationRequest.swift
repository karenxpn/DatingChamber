//
//  LocationRequest.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import SwiftUI

struct LocationRequest: View {
    
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            Image("location_request_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 220, height: 220)
            
            
            Text( NSLocalizedString("locationRequest", comment: "") )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            
            Text( NSLocalizedString("locationRequestMessage", comment: "") )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()

            ButtonHelper(disabled: false, label: NSLocalizedString("continue", comment: "")) {
                if locationManager.status == "request" {
                    locationManager.requestLocation()
                } else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }

        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        ).padding(30)
            .padding(.bottom, UIScreen.main.bounds.height * 0.1)
    }
}

struct LocationRequest_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequest()
    }
}
