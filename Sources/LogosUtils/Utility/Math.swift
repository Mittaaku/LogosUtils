//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 16/03/2023.
//

import Foundation

/// Finds a root of a function using the bisection method.
///
/// - Parameters:
///   - a: The left endpoint of the interval.
///   - b: The right endpoint of the interval.
///   - f: The function whose root is being sought.
///   - tolerance: The maximum error allowed in the approximation.
///
/// - Returns: The approximate root of the function, or nil if the bisection method fails.
public func bisectionMethod<T: BinaryFloatingPoint>(a: T, b: T, f: (T) -> T, tolerance: T) -> T? {
	var x = (a + b) / 2.0 // initial guess
	var a = a
	var b = b
	
	while abs(f(x)) > tolerance {
		let fx = f(x)
		let fa = f(a)
		let fb = f(b)
		
		if fx == 0 {
			// x is a root of f
			return x
		} else if fa * fx < 0 {
			// the root is in the left interval
			b = x
		} else if fb * fx < 0 {
			// the root is in the right interval
			a = x
		} else {
			// the bisection method fails
			return nil
		}
		x = (a + b) / 2.0 // update guess
	}
	return x
}
