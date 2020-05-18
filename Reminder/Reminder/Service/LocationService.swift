//
//  LocationService.swift
//  Reminder
//
//  Created by Chris Mercer on 18/05/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private override init(){}
    static let instance = LocationService()
    
    let locationManager = CLLocationManager()
    var authorised = false
    var shouldSetRegion = true
    
    func authorise() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        authorised = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorised = (status == CLAuthorizationStatus.authorizedAlways)
    }
    
    func updateLocation() {
        guard authorised else { return authorise() }
        shouldSetRegion = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard authorised else { return authorise() }
        print("got location")
        guard let currentLocaton = locations.first, shouldSetRegion else { return }
        let region = CLCircularRegion(center: currentLocaton.coordinate, radius: 20, identifier: "home")
        manager.stopMonitoring(for: region)
        shouldSetRegion = false
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard authorised else { return authorise() }
        print("did enter a region")
        NotificationCenter.default.post(name: NSNotification.Name("region.entered"), object: nil)
    }
}
