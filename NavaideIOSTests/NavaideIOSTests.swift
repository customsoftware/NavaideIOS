//
//  NavaideIOSTests.swift
//  NavaideIOSTests
//
//  Created by Kenneth Cluff on 7/17/25.
//

import Testing
@testable import NavaideIOS

struct NavaideIOSTests {

    @Test func convertVelocity() async throws {
        // Given
        // .metric = kilometers/hour
        // .imperial = miles/hour
        // .nautical = knots/hour
        let velocity: Double = 10
        let vu = VelocityUnit.imperial
        
        // When
        let mphPrime  = vu.convert(source: velocity, from: .imperial, to: .imperial)
        let mphMetric = vu.convert(source: velocity, from: .metric,   to: .imperial)
        let mphKts    = vu.convert(source: velocity, from: .nautical, to: .imperial)
        
        let metersImp   = vu.convert(source: velocity, from: .imperial, to: .metric)
        let metersPrime = vu.convert(source: velocity, from: .metric,   to: .metric)
        let metersKnots = vu.convert(source: velocity, from: .nautical, to: .metric)
        
        let ktsImperial = vu.convert(source: velocity, from: .imperial, to: .nautical)
        let ktsMetric   = vu.convert(source: velocity, from: .metric,   to: .nautical)
        let ktsPrime    = vu.convert(source: velocity, from: .nautical, to: .nautical)
        
        // Then
        #expect(mphPrime  == 10,   "The speed should have been 1609.3 mph")
        #expect(mphMetric == 6.2, "The speed should have been 6.2 mph")
        #expect(mphKts    == 11.5, "The speed should have been 11.5 mph")
        
        #expect(metersImp   == 4.5, "The speed should have been 4.5 kph")
        #expect(metersPrime == 10,  "The speed should have been 10 kph")
        #expect(metersKnots == 18.5, "The speed should have been 18.5 kph")
        
        #expect(ktsImperial == 11.5, "The speed should have been 11.5 kts")
        #expect(ktsMetric   == 5.4,"The speed should have been 5.4 kts")
        #expect(ktsPrime    == 10,  "The speed should have been 10 kts")
    }

    @Test func convertAltitude() async throws {
        // Given
        let altitude: Double = 1000
        let au = AltitudeUnit.imperial
        
        // When
        let meters      = au.convert(source: altitude, from: .imperial, to: .metric)
        let feet        = au.convert(source: altitude, from: .metric, to: .imperial)
        let metersPrime = au.convert(source: altitude, from: .imperial, to: .imperial)
        let feetPrime   = au.convert(source: altitude, from: .metric, to: .metric)
        
        // Then
        #expect(meters == 305.0,     "The altitude should have been 305.0 meters")
        #expect(feet == 3281.0,      "The altitude should have been 3281.0 feet")
        #expect(metersPrime == 1000, "The altitude should have been 1000 meters")
        #expect(feetPrime == 1000,   "The altitude should have been 1000 feet")
    }

    @Test func convertDistance() async throws {
        // Given
        let distance: Double = 100
        let du = DistanceUnit.imperial
        
        // When
        let mphPrime  = du.convert(source: distance, from: .imperial, to: .imperial)
        let mphMetric = du.convert(source: distance, from: .metric,   to: .imperial)
        let mphKts    = du.convert(source: distance, from: .nautical, to: .imperial)
        
        let metersImp   = du.convert(source: distance, from: .imperial, to: .metric)
        let metersPrime = du.convert(source: distance, from: .metric,   to: .metric)
        let metersKnots = du.convert(source: distance, from: .nautical, to: .metric)
        
        let ktsImperial = du.convert(source: distance, from: .imperial, to: .nautical)
        let ktsMetric   = du.convert(source: distance, from: .metric,   to: .nautical)
        let ktsPrime    = du.convert(source: distance, from: .nautical, to: .nautical)
        
        // Then
        #expect(mphPrime  == 100,   "The distance should have been 160.9 miles")
        #expect(mphMetric == 62.1,  "The distance should have been 62.1 miles")
        #expect(mphKts    == 115.1, "The distance should have been 115.1 miles")
        
        #expect(metersImp   == 160.9, "The distance should have been 160.9 kilometers")
        #expect(metersPrime == 100,   "The distance should have been 100 kilometers")
        #expect(metersKnots == 185.2, "The distance should have been 185.2 kilometers")
        
        #expect(ktsImperial == 86.9, "The distance should have been 86.9 nautical miles")
        #expect(ktsMetric   == 54.0, "The distance should have been 54.0 nautical miles")
        #expect(ktsPrime    == 100,  "The distance should have been 1000 nautical miles")
    }

}
