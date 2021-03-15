//
//  PerformanceTimer.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/2/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

import Foundation

public class PerformanceTimer {
    public let taskName: String?
    public let startTime: CFAbsoluteTime
    public var endTime: CFAbsoluteTime?

    public init(taskName: String? = nil) {
        self.taskName = taskName
        self.startTime = CFAbsoluteTimeGetCurrent()
    }

    public func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration!
    }

    public var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
