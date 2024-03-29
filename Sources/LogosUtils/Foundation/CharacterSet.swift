//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

// MARK: - Static variables
public extension CharacterSet {
	
	static var greekVowels = CharacterSet(charactersIn: "ΑαΕεΗηΙιΟοΥυΩω")
	
	static var greekConsonants = CharacterSet(charactersIn: "ΒβΓγΔδΖζΘθΚκΛλΜμΝνΞξΠπΡρΣσςΤτΦφΧχΨψ")
	
	static var greekNonInflective = CharacterSet(charactersIn: "\u{300}\u{301}\u{313}\u{314}")
	
	static var tabular = CharacterSet(charactersIn: "\t")
	
	/// Character set containing the invalid characters for file names.
	static var invalidFileNameCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|").union(.newlines).union(.illegalCharacters).union(.controlCharacters)
}
#endif
