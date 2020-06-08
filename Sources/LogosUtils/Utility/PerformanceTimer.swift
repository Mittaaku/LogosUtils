//
//  PerformanceTimer.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/2/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

import Foundation

class PerformanceTimer {

    let taskName: String
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?
    
    init(taskName: String) {
        self.taskName = taskName
        self.startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration!
    }

    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
