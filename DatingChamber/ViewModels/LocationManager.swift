//
//  LocationManager.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.11.22.
//

import CoreLocation
import SwiftUI
import Combine


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var navigate: Bool = false
    @Published var locationStatus: CLAuthorizationStatus?
    
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if location == nil {
            location = locations.first?.coordinate
            print(location)
            //            print(location)
            // update location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        navigate = true
    }
    
}
