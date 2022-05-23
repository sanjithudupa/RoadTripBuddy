//
//  LocationManager.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var lastLocation: CLLocation? = nil
    
    static var _instance:LocationManager? = nil;
    static func getInstance() -> LocationManager {
        if (_instance == nil) {
            _instance = LocationManager()
        }
        return _instance!;
    }

    override init() {
        super.init();
        if CLLocationManager.locationServicesEnabled() {
            print("CLLocationManager is available")
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.delegate = self;
        }
    }
    
    func getLocation() -> CLLocation {
        locationManager.requestLocation()
        if (locationManager.location == nil) {
            return getLocation()
        }
        return locationManager.location!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lastLocation = location;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle changes if location permissions
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }
    
    func beginLiveUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func dispose() {
        locationManager.stopUpdatingLocation()
    }
    
}
