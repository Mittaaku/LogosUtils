//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

extension BinaryInteger {
	
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
	
	/// LogosUtils: Get String from Int.
	///
	///		10.string -> "10"
	///
	var string: String {
		return String(self)
	}
	
	func checkBit(at position: Int) -> Bool {
		return (self & (1 << position)) != 0
	}
}
