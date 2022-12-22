//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: Properties
public extension Character {

	/// LogosUtils: Initialize a String from the Character.
    var string: String {
        return String(self)
    }
}

// MARK: Methods
public extension Character {
	
	func contains(diacritic: Diacritic) -> Bool {
		String(self).contains(diacritic: diacritic)
	}
	
	func contains(characterFromSet characterSet: CharacterSet, form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		String(self).contains(characterFromSet: characterSet, form: form)
	}
	
	func consists(ofCharactersFromSet characterSet: CharacterSet, form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		String(self).consists(ofCharactersFromSet: characterSet, form: form)
	}
}
