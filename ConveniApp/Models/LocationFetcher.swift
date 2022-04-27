//
//  LocationFetcher.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/10.
//

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            NotificationCenter.default.post(name: Constants.locationRequestApprovedNotification,
                                            object: nil, userInfo: nil)
        }
    }
    
    func lookUpCurrentLocation() async throws -> CLPlacemark? {
        // Use the last reported location.
        if let lastLocation = self.manager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            let locations = try await geocoder.reverseGeocodeLocation(lastLocation)
            
            return locations.first
        }
        
        return nil
    }
}
