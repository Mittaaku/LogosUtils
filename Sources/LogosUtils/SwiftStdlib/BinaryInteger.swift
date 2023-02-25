//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension BinaryInteger {
	
	var isZero: Bool {
		return self == 0
	}
}

// MARK: - Methods
public extension BinaryInteger {
	
	func dividedRoundingUp(by divisor: Self) -> Self {
		let divided = self / divisor
		let rem = self % divisor
		return rem == 0 ? divided : divided + 1
	}
}

