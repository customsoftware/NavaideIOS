//
//  ContentView.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/17/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var locationEngine = LocationEngine()
    
    var body: some View {
        NavigationSwiftUIView()
            .environmentObject(locationEngine)
        .padding()
    }
}

#Preview {
    ContentView()
}
