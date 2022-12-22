//
//  CharacterSet.swift
//  
//
//  Created by Tom-Roger Mittag on 21/12/2022.
//

import Foundation

// MARK: Methods
public extension CharacterSet {
	
	func containsPrecomposedUnicodeScalar(of scalar: UnicodeScalar) -> Bool {
		return containsUnicodeScalars(of: String(scalar), precomposed: true)
	}
	
	func containsUnicodeScalar(of character: Character, precomposed: Bool = true) -> Bool {
		return containsUnicodeScalars(of: String(character), precomposed: precomposed)
	}
	
	func containsUnicodeScalars(of string: String, precomposed: Bool = true) -> Bool {
		let stringToEvaluate = precomposed ? string.precomposedStringWithCanonicalMapping : string
		return stringToEvaluate.unicodeScalars.allSatisfy(contains(_:))
	}
}
