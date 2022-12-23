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
}
