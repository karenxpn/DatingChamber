//
//  APIHelper.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 16.01.23.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI


class APIHelper {
    static let shared = APIHelper()
    
    func voidRequest(action: () async throws -> Void) async -> Result<Void, Error> {
        do {
            try await action()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
