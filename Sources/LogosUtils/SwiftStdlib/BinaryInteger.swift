//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public extension BinaryInteger {
	
	var isZero: Bool {
		return self == 0
	}
	
	var isNotZero: Bool {
		return self != 0
	}
	
	var isPositive: Bool {
		return self > 0
	}
	
	var isEven: Bool {
		return (self % 2) == 0
	}
	
	var isOdd: Bool {
		return (self % 2) != 0
	}
	
	func checkBit(at position: Int) -> Bool {
		return (self & (1 << position)) != 0
	}
}
