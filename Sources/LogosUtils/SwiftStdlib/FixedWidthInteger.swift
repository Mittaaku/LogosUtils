//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

public extension FixedWidthInteger {
	
	internal var bytes: [UInt8] {
		var _endian = littleEndian
		let bytePtr = withUnsafePointer(to: &_endian) {
			$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) {
				UnsafeBufferPointer(start: $0, count: MemoryLayout<Self>.size)
			}
		}
		return [UInt8](bytePtr)
	}
	
	func checkBit(at index: Self) -> Bool {
		precondition(index >= 0 && index < Self.bitWidth, "Index out of range")
		return (self & (1 << index)) != 0
	}
	
	mutating func setBit(at index: Self) {
		precondition(index >= 0 && index < Self.bitWidth, "Index out of range")
		self |= (1 << index)
	}
	
	mutating func unsetBit(at index: Self) {
		precondition(index >= 0 && index < Self.bitWidth, "Index out of range")
		self &= ~(1 << index)
	}
}

internal func pow<T: FixedWidthInteger>(_ base: T, _ exponent: T) -> T {
	var answer: T = 1
	for _ in 0 ..< exponent {
		answer *= base
	}
	return answer
}
