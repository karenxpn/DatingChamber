//
//  SwipeCardActionSheet.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 10.11.22.
//

import SwiftUI

struct SwipeCardActionSheet: View {
    @EnvironmentObject var userVM: UserViewModel
    @Binding var showDialog: Bool
    @Binding var showReportConfirmation: Bool
    @Binding var reportReason: String
    @Binding var user: SwipeUserViewModel
    @Binding var cardAction: CardAction?
    let animation: Animation

    var reportUser: () -> ()
    var checkLastAndRequestMore: () -> ()

    
    
    
    var body: some View {
        CustomActionSheet {
            
            ActionSheetButtonHelper(icon: "report_icon",
                                    label: NSLocalizedString("reportUser", comment: ""),
                                    role: .destructive) {
                self.showReportConfirmation.toggle()
            }.alert(NSLocalizedString("chooseReason", comment: ""), isPresented: $showReportConfirmation, actions: {
                Button {
                    reportReason = NSLocalizedString("fraud", comment: "")
                    reportUser()
                    
                } label: {
                    Text( NSLocalizedString("fraud", comment: "") )
                }
                
                Button {
                    reportReason = NSLocalizedString("insults", comment: "")
                    reportUser()
                } label: {
                    Text( NSLocalizedString("insults", comment: "") )
                }
                
                Button {
                    reportReason = NSLocalizedString("fakeAccount", comment: "")
                    reportUser()
                } label: {
                    Text( NSLocalizedString("fakeAccount", comment: "") )
                }
                
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }
                
            })
            
            Divider()
            
            ActionSheetButtonHelper(icon: "block_icon",
                                    label: NSLocalizedString("block", comment: ""),
                                    role: .destructive) {
                showDialog.toggle()
                cardAction = .report
                withAnimation(animation) {
                    user.y = 1000;
                    checkLastAndRequestMore()
                }
                
                userVM.blockUser(uid: user.id)
            }
        }

    }
}
//
//struct SwipeCardActionSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SwipeCardActionSheet()
//    }
//}
