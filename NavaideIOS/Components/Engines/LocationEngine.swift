//
//  LocationEngine.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/17/25.
//

import Foundation
import CoreLocation

class LocationEngine: NSObject, ObservableObject {
    
    private static let location: CLLocationManager = CLLocationManager()
    private var hasAskedForPermission: Bool = false
    private let courseTimer = DataRecorder()
    private var lastLocation: CLLocation?
    private var currentLocation: CLLocation?
    
    @Published var altitude: Double = 0.0
    @Published var groundSpeed: Double = 0.0
    @Published var trueNorthDirection: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var heading: Double = 0.0
    @Published var directionOfTravel: Double = 0.0
    @Published var windDrift: Double = 0.0
    @Published var verticalVelocity: Double = 0.0
    
    @Published var isTracking: Bool = false
    @Published var isEnabled: Bool {
        didSet {
            guard CLLocationManager.headingAvailable() else {
                print("Location services need to be available on the device")
                return
                }
            
            if !hasAskedForPermission {
                LocationEngine.location.requestWhenInUseAuthorization()
                // TODO: store to persist this
                hasAskedForPermission = true
            }
            
            if isEnabled,
               LocationEngine.location.authorizationStatus == .authorizedWhenInUse  {
                Self.location.startUpdatingLocation()
                courseTimer.startRecording { [self] in
                    computeDrift()
                }
            } else {
                Self.location.stopUpdatingLocation()
                courseTimer.stopRecording()
                reset()
            }
        }
    }
    var isLogging: Bool = false {
        didSet {
            if isLogging {
                // Enable a time that captures current location every second and stores it
                print("Logging enabled")
            }
        }
    }
    
    override init() {
        self.isEnabled = false
        super.init()
        LocationEngine.location.delegate = self
        LocationEngine.location.headingFilter = 1
    }
    
    func start() {
        if LocationEngine.location.authorizationStatus == .notDetermined {
            LocationEngine.location.requestWhenInUseAuthorization()
        }
    }
    
    private func reset() {
        altitude = 0
        groundSpeed = 0
        trueNorthDirection = 0
        directionOfTravel = 0
        heading = 0
        latitude = 0
        longitude = 0
        directionOfTravel = 0
        windDrift = 0
    }
    
    private func computeDrift() {
        // Measure the azimuth between the two locations.
        windDrift = computeWindDrift()
        
        self.lastLocation = currentLocation
        self.currentLocation = nil
    }
}

extension LocationEngine: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
        trueNorthDirection = newHeading.trueHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location manager quit working with error: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            isTracking = true
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            // Handle authorization denied
            isTracking = false
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Location manager has paused")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }

        /// Store this so wind drift can be computed
        currentLocation = lastLocation
        
        /// Natively measured in meters
        altitude = lastLocation.altitude
        
        /// Natively measured in meters per second, convert to kph (speed * 60 * 60)/1000
        groundSpeed = lastLocation.speed * 3.6
        
        heading = lastLocation.course
        latitude = lastLocation.coordinate.latitude
        longitude = lastLocation.coordinate.longitude
        if let currentLocation {
            directionOfTravel = calculateCourse(from: lastLocation.coordinate, to: currentLocation.coordinate)
            verticalVelocity = computeVerticalVelocity(from: lastLocation, to: currentLocation)
        } else {
            directionOfTravel = 0.0
            verticalVelocity = 0.0
        }
    }
}

fileprivate extension LocationEngine {
    func computeWindDrift() -> Double {
        guard let current = currentLocation, let last = lastLocation else {
            return 0
        }
        var retValue: Double = 0
        
        // Take direction... which way we're facing
        let heading = directionOfTravel
        
        // Take course over the ground
        let course = calculateCourse(from: last.coordinate, to: current.coordinate)
        
        // Take the ground speed... in kilometers/hour
        let speed = groundSpeed
        
        // Compute the vertical component of the triangle, that's the crosswind speed
        let windSpeed = computeWindSpeed(heading: course, distance: speed)
        
        // Compute delta heading
        let deltaTime = current.timestamp.timeIntervalSince(last.timestamp)
        
        retValue = windSpeed / deltaTime
        
        return retValue
    }
    
    func computeWindSpeed(heading: Double, distance: Double) -> Double {
        // Convert angles from degrees to radians for trigonometric functions
        let deltaAngle_radians = heading * .pi / 180.0

        // Apply the Law of Sines to find side B
        return distance * sin(deltaAngle_radians)
    }
    
    func calculateCourse(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Double {
        let startLocation = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let endLocation = CLLocation(latitude: end.latitude, longitude: end.longitude)

        let angle = atan2(
            sin(end.longitude - start.longitude) * cos(end.latitude),
            cos(start.latitude) * sin(end.latitude) - sin(start.latitude) * cos(end.latitude) * cos(end.longitude - start.longitude)
        )

        let heading = (angle * 180.0 / .pi + 360).truncatingRemainder(dividingBy: 360)
        return heading
    }

    func computeVerticalVelocity(from start: CLLocation, to current: CLLocation) -> Double {
        // For now.
        // Compute delta heading
        let deltaTime = start.timestamp.timeIntervalSince(current.timestamp)
        
        // Take delta altitude divide that by time and compute to value/minute
        let deltaAltitude = start.altitude - current.altitude
        
        guard deltaTime > 0 , abs(deltaAltitude) > 0 else {
            return 0.0
        }
        // Time is in seconds, Altitude is in meters, so this is meters/second
        return deltaAltitude / deltaTime
    }
}
