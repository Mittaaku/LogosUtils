//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
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
        return totalDuration!
    }
	
	public var currentDuration: CFAbsoluteTime {
		return CFAbsoluteTimeGetCurrent() - startTime
	}

    public var totalDuration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
