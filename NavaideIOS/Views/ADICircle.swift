//
//  ADISircle.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 8/1/25.
//

import SwiftUI

struct ADICircle : Shape {
    private var radius : CGFloat
    private var center : CGPoint
    private var verticalOffset : Int
    private var horizontalPadding: CGFloat
    private var geometry: GeometryProxy
    @State private var lineColor: Color = .primary
    
    init(geometry: GeometryProxy, verticalOffset: Int, horizontalPadding: CGFloat) {
        self.geometry = geometry
        self.verticalOffset = verticalOffset
        self.horizontalPadding = horizontalPadding
        
        radius = (geometry.size.width/2) - horizontalPadding/2
        center = CGPoint(x: Int(geometry.size.width/2),
                         y: Int(geometry.size.height/2) + verticalOffset)
        
    }
    
    func path(in rect: CGRect) -> Path {
        var mPath = Path()
        
        // Calculating the coordinates of center
        let Xcenter = center.x - rect.origin.x
        let Ycenter =  center.y - rect.origin.y
        
        // For circle
        mPath.addArc(
            center: CGPoint(x: Xcenter, y: Ycenter),
            radius: radius, startAngle: Angle(degrees: 0.0),
            endAngle: Angle(degrees: 360.0),
            clockwise: true
        )
        return mPath
    }
}
