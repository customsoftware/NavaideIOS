import UIKit

let baseString = "https://aviationweather.gov/api/data/airport?bbox=<<geoString>>&format=json"
let geoBoxString = "40.0,-112,41.9,-111.5"

let airportQueryString = baseString.replacingOccurrences(of: "<<geoString>>", with: geoBoxString)
print(airportQueryString)

struct Runway: Hashable, Codable {
    var id: String
    var dimension: String
    var surface: String
    var alignment: String
    var direction: Int? = 0
    
    var runwayLength: Int {
        let runwayComponents = dimension.components(separatedBy: "x")
        let retValue = (runwayComponents[0] as NSString).intValue
        return Int(retValue)
    }
    
    func getRunwayAxis() -> (Int, Int) {
        let axisComponents = id.components(separatedBy: "/")
        let axis1 = (axisComponents[0] as NSString).integerValue
        let axis2 = (axisComponents[1] as NSString).integerValue
        return (axis1, axis2)
    }
}

struct AirportData: Hashable, Codable {
    var name: String
    var faaId: String
    var icaoId: String?
    var runways: [Runway]
    
    mutating func setRunways() {
        guard runways.count > 0 else { return }
        var runwayHolder: [Runway] = []
        runways.forEach { runway in
            guard runway.id.contains("/") else { return }
            let directions = runway.id.components(separatedBy: "/")
            guard directions.count == 2 else { return }
            let firstDirection = directions.first!
            let lastDirection = directions.last!
            guard lastDirection != firstDirection else { return }
            
            runwayHolder.append(Runway(id: runway.id, dimension: runway.dimension, surface: runway.surface, alignment: runway.alignment, direction: NSString(string: firstDirection).integerValue))
            runwayHolder.append(Runway(id: runway.id, dimension: runway.dimension, surface: runway.surface, alignment: runway.alignment, direction: NSString(string: lastDirection).integerValue))
        }
        runways = runwayHolder
    }
}

let url = URL(string: airportQueryString)!

do {
    let data = try Data(contentsOf: url)
    let airportData = try JSONDecoder().decode([AirportData].self, from: data)
    
    let airports = airportData.filter( { airport in
       return airport.icaoId != nil
    })
    
    airports.map({ airport in
        var anAirport = airport
        anAirport.setRunways()
        print(airport.name)
        anAirport.runways.map({ runway in
            print("Runway ID: \(runway.direction ?? -1) Dimension: \(runway.dimension)")
        })
    })
    
} catch {
    print("Failed to fetch data")
}
