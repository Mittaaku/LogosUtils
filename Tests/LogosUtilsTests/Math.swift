//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 16/03/2023.
//

import Foundation
import LogosUtils
import XCTest

class BisectionMethodTests: XCTestCase {
	func testBisectionMethod() {
		// Test function f(x) = x^2 - 2, find root between 0 and 2 with tolerance of 0.0001
		func f(x: Double) -> Double {
			return x*x - 2
		}
		
		let expectedRoot = sqrt(2.0)
		let tolerance = 0.0001
		
		if let root = bisectionMethod(a: 0.0, b: 2.0, f: f, tolerance: tolerance) {
			XCTAssertEqual(root, expectedRoot, accuracy: tolerance)
		} else {
			XCTFail("The bisection method failed to converge.")
		}
	}
}
