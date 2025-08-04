import UIKit
import CoreLocation

//enum AltitudeUnit: CaseIterable, Identifiable {
//    case metric
//    case imperial
//    
//    var id: Self { self } // Conforming to Identifiable
//    var symbol: String {
//        switch self {
//        case .metric:
//            return "Meters"
//        case .imperial:
//            return "Feet"
//        }
//    }
//    
//    static func convert(source: Double, from: AltitudeUnit, to target: AltitudeUnit) -> Double {
//        let retValue: Double
//        switch (from, target) {
//            case (.metric, .imperial):
//            retValue = source * 3.28084
//        case (.imperial, .metric):
//            retValue = source * 0.3048
//        default:
//            retValue = source
//        }
//        return round(retValue)
//    }
//}
//
//let originalSpeed: Double = 6000
//let speedMiles:  Double = AltitudeUnit.convert(source: originalSpeed, from: .metric, to: .imperial)
//let speedKlicks: Double = AltitudeUnit.convert(source: originalSpeed, from: .metric, to: .metric)
//
//print("We're at \(speedMiles) feet altitude.")
//print("We're at \(speedKlicks) meters altitude.")
//
let startingLocation: CLLocationCoordinate2D = .init(latitude: 40.1, longitude: 111.30)
let endingLocation: CLLocationCoordinate2D = .init(latitude: 40.1, longitude: 111.45)

let startLocation: CLLocation = CLLocation(coordinate: startingLocation, altitude: 1500, horizontalAccuracy: .zero, verticalAccuracy: .zero, course: 270, speed: 0, timestamp: Date())

let endLocation: CLLocation = CLLocation(coordinate: endingLocation, altitude: 1500, horizontalAccuracy: .zero, verticalAccuracy: .zero, course: 270, speed: 0, timestamp: Date())

let distanceFromStart: Double = startLocation.distance(from: endLocation)

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

let course = calculateCourse(from: startingLocation, to: endingLocation)

let heading = 270.0

print("Distance: \(round(distanceFromStart)) meters")
print("Course (degrees): \(round(course*10)/10) degrees")

print("Delta from course: \(course - heading)")

if course - heading < 0 {
    print("Drifting to the left")
} else if course == heading {
    print("On course")
} else {
    print("Drifting to the right")
}
