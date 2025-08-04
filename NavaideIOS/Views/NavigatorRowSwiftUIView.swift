//
//  NavigatorRowSwiftUIView.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/17/25.
//

import SwiftUI

struct NavigatorRowSwiftUIView: View {
    private var rowLabel: String
    private var rowValue: String
    
    init(rowLabel: String, rowValue: String) {
        self.rowLabel = rowLabel
        self.rowValue = rowValue
    }
    
    var body: some View {
        HStack {
            Text(rowLabel)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            Spacer()
            Text(rowValue)
                .font(.title)
        }
    }
}

#Preview {
    NavigatorRowSwiftUIView(rowLabel: "North", rowValue: "230")
}
