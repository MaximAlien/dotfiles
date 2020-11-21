#!/usr/bin/swift

import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override init() {
        super.init()

        enableLocationServices()
    }

    func enableLocationServices() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 100.0 // meters
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function)")
        
        var authorizationStatus: String
        switch status {
        case .restricted:
            authorizationStatus = "restricted"
            break
            
        case .denied:
            authorizationStatus = "denied"
            break
            
        case .authorizedWhenInUse:
            authorizationStatus = "authorizedWhenInUse"
            break
            
        case .notDetermined:
            authorizationStatus = "notDetermined"
            break
            
        case .authorizedAlways:
            authorizationStatus = "authorizedAlways"
            break
            
        @unknown default:
            fatalError()
        }
        
        print("Current location authorization status: \(authorizationStatus)")
    }

    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last! as CLLocation
        let locationCoordinate: CLLocationCoordinate2D = lastLocation.coordinate
        
        print("Latitude: \(locationCoordinate.latitude), Longitude: \(locationCoordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            print("Location updates are not authorized. Error: \(error)")
            manager.stopUpdatingLocation()
            return
        }
    }
}

let runLoop = CFRunLoopGetCurrent()

let locationController = LocationController()

CFRunLoopRun()
exit(EXIT_SUCCESS)