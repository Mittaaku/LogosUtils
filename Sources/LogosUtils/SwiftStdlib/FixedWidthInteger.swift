//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public extension FixedWidthInteger {
	
	// Credit: https://stackoverflow.com/questions/29970204/split-uint32-into-uint8-in-swift
	var bytes: [UInt8] {
		var _endian = littleEndian
		let bytePtr = withUnsafePointer(to: &_endian) {
			$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) {
				UnsafeBufferPointer(start: $0, count: MemoryLayout<Self>.size)
			}
		}
		return [UInt8](bytePtr)
	}
	
	func pow(to power: Self) -> Self {
		return LogosUtils.pow(self, power)
	}
}

public func pow<T: FixedWidthInteger, U: FixedWidthInteger>(_ base: T, _ power: U) -> T {
	var answer: T = 1
	for _ in 0 ..< power {
		answer *= base
	}
	return answer
}

precedencegroup PowerPrecedence {
	higherThan: MultiplicationPrecedence
}

infix operator **: PowerPrecedence
/// Value of exponentiation.
///
/// - Parameters:
///   - lhs: base value.
///   - rhs: exponent value.
/// - Returns: exponentiation value.
public func **<T: FixedWidthInteger, U: FixedWidthInteger>(lhs: T, rhs: U) -> T {
	return pow(lhs, rhs)
}
