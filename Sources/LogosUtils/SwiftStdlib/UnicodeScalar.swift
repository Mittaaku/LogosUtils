//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

public extension UnicodeScalar {
	
	/// Checks if the Unicode scalar contains a specific diacritic.
	///
	/// - Parameters:
	///   - diacritic: The `Diacritic` to search for.
	///
	/// - Returns: `true` if the Unicode scalar contains the diacritic, otherwise `false`.
	func contains(diacritic: Diacritic) -> Bool {
		String(self).contains(diacritic: diacritic)
	}
	
	/// Checks if the Unicode scalar contains a character from the specified `CharacterSet`.
	///
	/// - Parameters:
	///   - characterSet: The `CharacterSet` to search for.
	///   - form: The Unicode normalization form to use. Defaults to `.decomposedWithCanonicalMapping`.
	///
	/// - Returns: `true` if the Unicode scalar contains a character from the `CharacterSet`, otherwise `false`.
	func contains(characterFromSet characterSet: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		String(self).contains(characterFromSet: characterSet, inForm: form)
	}
	
	/// Checks if the Unicode scalar consists solely of characters from the specified `CharacterSet`.
	///
	/// - Parameters:
	///   - characterSet: The `CharacterSet` to check against.
	///   - form: The Unicode normalization form to use. Defaults to `.decomposedWithCanonicalMapping`.
	///
	/// - Returns: `true` if the Unicode scalar consists solely of characters from the `CharacterSet`, otherwise `false`.
	func consists(ofCharactersFromSet characterSet: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		String(self).consists(ofCharactersFromSet: characterSet, inForm: form)
	}
}

#endif
