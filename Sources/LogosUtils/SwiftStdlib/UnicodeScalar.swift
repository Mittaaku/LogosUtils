//
//  UnicodeScalar.swift
//  
//
//  Created by Tom-Roger Mittag on 22/12/2022.
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
	
	func decompositionContains(characterFromSet characterSet: CharacterSet) -> Bool {
		String(self).decomposedStringWithCanonicalMapping.contains(characterFromSet: characterSet)
	}
	
	func decompositionConsists(ofCharactersFromSet characterSet: CharacterSet) -> Bool {
		String(self).decomposedStringWithCanonicalMapping.consists(ofCharactersFromSet: characterSet)
	}
}
