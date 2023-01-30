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
	
	public init(taskName: String? = nil, closure: () -> Void) {
		self.taskName = taskName
		self.startTime = CFAbsoluteTimeGetCurrent()
		closure()
		endTime = CFAbsoluteTimeGetCurrent()
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
