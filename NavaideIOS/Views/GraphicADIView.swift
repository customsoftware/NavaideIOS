//
//  GraphicADIView.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/28/25.
//

import SwiftUI

struct GraphicADIView: View {
    
    let offset: Int = 0
    let boxWidth: CGFloat = 100.0
    let boxHeight: CGFloat = 30.0
    
    @State private var lineColor: Color = .primary
    let frameDimension: CGFloat
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    // Heading Box
                    Path(CGRect(x: (geometry.size.width/2) - boxWidth/2, y: 20, width: boxWidth, height: boxHeight))
                        .fill(.clear)
                        .stroke(lineColor)
                    // Compass Rose
                    ADICircle(geometry: geometry, verticalOffset: offset, horizontalPadding: 20.0)
                        .stroke(lineColor, lineWidth: 2)
                    // Altitude Box
                    Path(
                        CGRect(
                            x: geometry.size.width - (boxHeight + 20),
                            y: (geometry.size.height/2) - boxWidth/2,
                            width: boxHeight,
                            height: boxWidth))
                            .fill(.clear)
                            .stroke(lineColor)
                    // Speed Box
                    Path(
                        CGRect(
                            x: 20,
                            y: (geometry.size.height/2) - boxWidth/2,
                            width: boxHeight,
                            height: boxWidth
                        )
                    )
                            .fill(.clear)
                            .stroke(lineColor)
                }
                .frame(width: geometry.size.width, height: geometry.size.height + CGFloat(offset))
            }
        }
        .clipped()
        .frame(width: frameDimension, height: frameDimension)
    }
    

}

#Preview {
    GraphicADIView(frameDimension: 395)
}
