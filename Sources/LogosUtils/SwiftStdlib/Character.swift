//
//  Character.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/8/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
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
}
