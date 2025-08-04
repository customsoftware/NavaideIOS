//
//  LocationExtension.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/17/25.
//

import Foundation

extension Double {
    var velocityString: String {
        String(format: "%.0f", self)
    }
    
    var distanceString: String {
        String(format: "%.2f", self)
    }
    
    var altitudeString: String {
        String(format: "%.1f", self)
    }
    
    var headingString: String {
        String(format: "%.0f", self)
    }
    
    var mapString: String {
        String(format: "%.3f", self)
    }
}
