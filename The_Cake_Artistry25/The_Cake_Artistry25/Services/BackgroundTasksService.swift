//
//  BackgroundTask.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-07-29.
//

import Foundation
import BackgroundTasks

class BackgroundTaskService {
    static func scheduleTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.cakeapp.refresh", using: nil) { task in
            // Perform background fetch or cleanup
            task.setTaskCompleted(success: true)
        }
    }
}
