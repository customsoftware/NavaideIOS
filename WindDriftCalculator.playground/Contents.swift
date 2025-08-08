import Foundation

let course: Double = 47.0       // Degrees
let heading: Double = 44.0      // Degrees
let distance: Double = 64.2    // Meters

let bearing: Double = course - heading

extension Double {
    var roundToTwo: Double {
        (self * 100.0).rounded() / 100.0
    }
}


func calculateTriangleSides(heading: Double, distance: Double) -> (crosswind: Double, speed: Double)? {

    // Convert angles from degrees to radians for trigonometric functions
    let deltaAngle_radians = heading * .pi / 180.0

    // Apply the Law of Sines to find side B
    let crossWind = distance * sin(deltaAngle_radians)
 
    print(crossWind.roundToTwo)
    
    let kilometersPerHour = crossWind * 3.6
    let milesPerHour = kilometersPerHour / 1.609
    
    
    return (crossWind, milesPerHour)
}

let (crossWind, milesPerHour) = calculateTriangleSides(heading: distance, distance: bearing) ?? (0, 0)

print("Cross wind component: \(crossWind.roundToTwo) meters")
print("Cross wind speed: \(milesPerHour.roundToTwo) miles per hour")
