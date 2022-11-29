//
//  FixedWidthInteger.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/15/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

import Foundation

extension FixedWidthInteger {
	
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
}
