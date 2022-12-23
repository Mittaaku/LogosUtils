//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

// MARK: Properties
public extension UnicodeScalar {
	
	/// LogosUtils: Initialize a String from the UnicodeScalar.
	var string: String {
		return String(self)
	}
}

// MARK: Methods
public extension UnicodeScalar {
	
	func contains(diacritic: Diacritic) -> Bool {
		String(self).contains(diacritic: diacritic)
	}
	
	func contains(characterFromSet characterSet: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		String(self).contains(characterFromSet: characterSet, inForm: form)
	}
	
	func consists(ofCharactersFromSet characterSet: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		String(self).consists(ofCharactersFromSet: characterSet, inForm: form)
	}
}
