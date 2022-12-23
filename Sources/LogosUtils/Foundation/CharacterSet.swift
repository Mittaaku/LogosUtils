//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

// MARK: Static variables
public extension CharacterSet {
	
	static var greekVowels = CharacterSet(charactersIn: "ΑαΕεΗηΙιΟοΥυΩω")
	
	static var greekConsonants = CharacterSet(charactersIn: "ΒβΓγΔδΖζΘθΚκΛλΜμΝνΞξΠπΡρΣσςΤτΦφΧχΨψ")
	
	static var greekNonInflective = CharacterSet(charactersIn: "\u{300}\u{301}\u{313}\u{314}")
}

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
