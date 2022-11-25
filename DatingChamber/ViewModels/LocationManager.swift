//
//  LocationManager.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 09.11.22.
//

import CoreLocation
import SwiftUI
import Combine
import GeoFire

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @AppStorage("userID") var userID: String = ""

    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var navigate: Bool = false
    @Published var locationStatus: CLAuthorizationStatus?
    
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var userManager: UserServiceProtocol
    
    init( userManager: UserServiceProtocol = UserService.shared) {
        self.userManager = userManager
        self.locationStatus = self.manager.authorizationStatus
        super.init()
    }
    
    convenience override init() {
        self.init(userManager: UserService.shared)
    }
    
    var status: String {
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            return "true"
        } else if locationStatus == .notDetermined {
            return "request"
        } else {
            return "settings"
        }
    }
    
    func initLocation() {
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        if status == "true" {
            manager.startMonitoringSignificantLocationChanges()
        } else if status == "request" {
            manager.requestWhenInUseAuthorization()
            manager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func requestLocation() {
        initLocation()
        manager.requestWhenInUseAuthorization()
        manager.startMonitoringSignificantLocationChanges()
    }
    
    
    @MainActor func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first?.coordinate
        if let location {
            let locationModel = LocationModel(hash: GFUtils.geoHash(forLocation: location),
                                              lat: location.latitude,
                                              lng: location.longitude)
            self.updateLocation(location: locationModel)
        }      
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        navigate = true
    }
    
    @MainActor func updateLocation(location: LocationModel) {
        Task {
            let _ = await userManager.updateLocation(userID: userID, location: location)
        }
    }
    
}
