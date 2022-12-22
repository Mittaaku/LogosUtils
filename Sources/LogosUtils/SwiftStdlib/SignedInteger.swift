//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension SignedInteger {
	
    var abs: Self {
        return Swift.abs(self)
    }

    var isNegative: Bool {
        return self < 0
    }
}
