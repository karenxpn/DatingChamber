//
//  NotificationsRequest.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 25.11.22.
//

import SwiftUI

struct NotificationsRequest: View {
    
    @StateObject var notificationsVM = NotificationsViewModel()
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            Image("notification_request_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 140)
            
            
            Text( NSLocalizedString("notificationRequest", comment: "") )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 30))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            
            Text( NSLocalizedString("notificationRequestMessage", comment: "") )
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 16))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()

            ButtonHelper(disabled: false, label: NSLocalizedString("continue", comment: "")) {
                notificationsVM.checkPermissionStatus { status in
                    if status == .notDetermined {
                        notificationsVM.requestPermission()
                    } else {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
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

struct NotificationsRequest_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsRequest()
    }
}
