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
        VStack(spacing: 20) {
            
            Spacer()
            Image("notification_request_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 220, height: 220)
            
            
            TextHelper(text: NSLocalizedString("notificationRequest", comment: ""),fontName: "Inter-SemiBold", fontSize: 30)
                .multilineTextAlignment(.center)
            
            TextHelper(text: NSLocalizedString("notificationRequestMessage", comment: ""))                .multilineTextAlignment(.center)
            
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
            .padding(.bottom, UIScreen.main.bounds.height * 0.15)
    }
}

struct NotificationsRequest_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsRequest()
    }
}
