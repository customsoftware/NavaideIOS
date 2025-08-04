//
//  LocationEnumerations.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/17/25.
//

import Foundation

enum LocationErrors: Error {
    case locationHeadingNotAvailable
    case locationNotAvailable
}

enum DisplayMode: CaseIterable, Identifiable {
    var id: Self { self } // Conforming to Identifiable
    
    case text
    case graphical
    
    var value: String {
        switch self {
        case .text:
            return "Text"
        case .graphical:
            return "Graphic"
        }
    }
}

enum AltitudeUnit: CaseIterable, Identifiable {
    case metric
    case imperial
    
    var id: Self { self } // Conforming to Identifiable
    var symbol: String {
        switch self {
        case .metric:
            return "Meters"
        case .imperial:
            return "Feet"
        }
    }
    
    /// This converts feet to meters and back
    func convert(source: Double, from: AltitudeUnit, to target: AltitudeUnit) -> Double {
        let retValue: Double
        switch (from, target) {
            case (.metric, .imperial):
            retValue = source * 3.28084
        case (.imperial, .metric):
            retValue = source * 0.3048
        default:
            retValue = source
        }
        return round(retValue)
    }
}

enum VelocityUnit: CaseIterable, Identifiable {
    var id: Self { self } // Conforming to Identifiable
    
    case metric
    case imperial
    case nautical
    
    var symbol: String {
        switch self {
        case .metric:
            return "Metric"
        case .imperial:
            return "Standard"
        case .nautical:
            return "Knots"
        }
    }
    
    /// This converst miles per hour to meters per second, miles per hour to nautical miles per hour, and back
    func convert(source: Double, from: VelocityUnit, to target: VelocityUnit) -> Double {
        let retValue: Double
        switch (from, target) {
        case (.metric, .imperial):
            retValue = source * 0.621371
        case (.metric, .nautical):
            retValue = source * 0.539957
        case (.imperial, .metric):
            retValue = source * 0.44704
        case (.imperial, .nautical):
            retValue = source * 1.15078
        case (.nautical, .metric):
            retValue = source * 1.852
        case (.nautical, .imperial):
            retValue = source * 1.15078
        default:
            retValue = source
        }
        
        return round(retValue * 10)/10
    }
}

enum DistanceUnit: CaseIterable, Identifiable {
    var id: Self { self } // Conforming to Identifiable
    
    case metric
    case imperial
    case nautical
    
    var symbol: String {
        switch self {
        case .metric:
            return "Metric"
        case .imperial:
            return "Standard"
        case .nautical:
            return "Knots"
        }
    }
    
    /// This converts distance, miles to kilometers, miles to nautical miles, nautical miles to kilometers and back
    func convert(source: Double, from: DistanceUnit, to target: DistanceUnit) -> Double {
        let retValue: Double
        switch (from, target) {
        case (.metric, .imperial):
            retValue = source * 0.621371
        case (.metric, .nautical):
            retValue = source * 0.539957
        case (.imperial, .metric):
            retValue = source * 1.60934
        case (.imperial, .nautical):
            retValue = source * 0.868976
        case (.nautical, .metric):
            retValue = source * 1.8520
        case (.nautical, .imperial):
            retValue = source * 1.15078
        default:
            retValue = source
        }
        
        return round(retValue * 10)/10
    }
}
