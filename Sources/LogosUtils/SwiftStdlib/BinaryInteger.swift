//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 29/11/2022.
//

import Foundation

extension BinaryInteger {
	
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
	var string: Int? {
		return Int(self)
	}
}
