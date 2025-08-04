//
//  NavigationSwiftUIView.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/17/25.
//

import SwiftUI

struct NavigationSwiftUIView: View {
    
    @EnvironmentObject private var locator: LocationEngine
    @State private var displayMode: DisplayMode = .text
    @State private var velocityOptions: VelocityUnit = .imperial
    @State private var altitudeOptions: AltitudeUnit = .metric
    @State private var isShowingDisplayOptions: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                topView()
                    .padding()
                    .popover(isPresented: $isShowingDisplayOptions) {
                        displayOptions()
                            .frame(maxWidth: geometry.size.width - 40, minHeight: 180)
                            .presentationCompactAdaptation(.popover)
                    }
                
                GeometryReader { geometry in
                    VStack {
                        GraphicADIView(frameDimension: geometry.size.width)
                        Divider()
                        listView()
                            .frame(maxHeight: 220)
                    }
                }

            }
            .task {
                locator.start()
            }
        }
        
    }
    
    func topView() -> some View {
        VStack {
            if locator.isTracking {
                HStack {
                    Button("\(locator.isEnabled ? "Dis" : "En")able GPS", systemImage: "map.circle") {
                        locator.isEnabled.toggle()
                        UIApplication.shared.isIdleTimerDisabled = locator.isEnabled
                    }
                    
                    Spacer()
                    Button("Settings") {
                        isShowingDisplayOptions.toggle()
                    }
//                    Picker("Velocity Options", selection: $displayMode) {
//                        ForEach(DisplayMode.allCases) { unit in
//                            Text(unit.value)
//                                .tag(unit) // Important for associating the view with the enum case
//                        }
//                    }
//                    .padding(.leading, Dimensions.Width.standard)
//                    .padding(.trailing, Dimensions.Width.standard)
//                    .pickerStyle(.segmented)
                }
                
            } else {
                Text("You must enable tracking to use the app")
            }
        }
    }
    
    func listView() -> some View {
        List {
            NavigatorRowSwiftUIView(rowLabel: "Heading:", rowValue: locator.heading.headingString)
            
            NavigatorRowSwiftUIView(rowLabel: "Direction:", rowValue: locator.directionOfTravel.headingString)
            
            NavigatorRowSwiftUIView(rowLabel: "Altitude:", rowValue: altitudeOptions.convert(source:locator.altitude, from: .metric, to: altitudeOptions).altitudeString)
            
            NavigatorRowSwiftUIView(rowLabel: "Speed:", rowValue: velocityOptions.convert(source:locator.groundSpeed, from: .metric, to: velocityOptions).velocityString)
            
//            NavigatorRowSwiftUIView(rowLabel: "Latitude:", rowValue: locator.latitude.mapString)
//            
//            NavigatorRowSwiftUIView(rowLabel: "Longitude:", rowValue: locator.longitude.mapString)
        }
    }
    
    func displayOptions() -> some View {
        
        VStack {
            Text("Distance and Speed Options: \(velocityOptions.symbol)")
            Picker("Velocity Options", selection: $velocityOptions) {
                ForEach(VelocityUnit.allCases) { unit in
                    Text(unit.symbol)
                        .tag(unit) // Important for associating the view with the enum case
                }
            }
            .padding(.leading, Dimensions.Width.standard)
            .padding(.trailing, Dimensions.Width.standard)
            .pickerStyle(.segmented)
            
            Text("Altitude Options: \(altitudeOptions.symbol)")
            Picker("Altitude Options", selection: $altitudeOptions) {
                ForEach(AltitudeUnit.allCases) { unit in
                    Text(unit.symbol)
                        .tag(unit) // Important for associating the view with the enum case
                }
            }
            .pickerStyle(.segmented)
            .padding(.leading, Dimensions.Width.standard)
            .padding(.trailing, Dimensions.Width.standard)
        }
    }
}

#Preview {
    NavigationSwiftUIView()
        .environmentObject(LocationEngine())
}
