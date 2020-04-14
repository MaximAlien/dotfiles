#!/usr/bin/swift

import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override init() {
        super.init()

        enableBasicLocationServices()
    }

    func enableBasicLocationServices() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 100.0 // meters
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function)")

        switch status {
        case .restricted, .denied:
            break

        case .authorizedWhenInUse:
            break

        case .notDetermined, .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }

    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!

        print("Last location: \(lastLocation)")
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