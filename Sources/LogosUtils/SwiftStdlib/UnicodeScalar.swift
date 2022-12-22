//
//  UnicodeScalar.swift
//  
//
//  Created by Tom-Roger Mittag on 22/12/2022.
//

import Foundation

// MARK: Methods
public extension UnicodeScalar {
	
	/// LogosUtils: Initialize a String from the UnicodeScalar.
	var string: String {
		return String(self)
	}
	
	func contains(diacritic: Diacritic) -> Bool {
		String(self).contains(diacritic: diacritic)
	}
}
