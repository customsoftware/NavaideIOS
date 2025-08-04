//
//  CourseTimer.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 7/19/25.
//

import Foundation

class DataRecorder {
    var timer: Timer?
    
    func startRecording(operation: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            operation()
        }
    }
    
    func stopRecording() {
        timer?.invalidate() // Invalidate the timer to stop it from firing
        timer = nil // Release the timer object
    }
}
