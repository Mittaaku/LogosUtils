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

// MARK: Static properties and methods
public extension Character {
	
	static let grave = Character("\u{300}")
	static let acute = Character("\u{301}")
	static let smoothBreathing = Character("\u{313}")
	static let roughBreathing = Character("\u{314}")
	static let circumflex = Character("\u{342}")
	static let iotaSubscript = Character("\u{345}")
}

// MARK: - Properties
public extension Character {

	/// LogosUtils: Get String from Character.
	///
	///		"C".string -> "C"
	///
    var string: String {
        return String(self)
    }
	
	var hasAcute: Bool {
		return CharacterSet.greekLettersWithAcute.containsUnicodeScalar(of: self)
	}
	
	var hasGrave: Bool {
		return CharacterSet.greekLettersWithGrave.containsUnicodeScalar(of: self)
	}
	
	var hasSmoothBreathing: Bool {
		return CharacterSet.greekLettersWithSmoothBreathing.containsUnicodeScalar(of: self)
	}
	
	var hasRoughBreathing: Bool {
		return CharacterSet.greekLettersWithRoughBreathing.containsUnicodeScalar(of: self)
	}
	
	var hasCircumflex: Bool {
		return CharacterSet.greekLettersWithCircumflex.containsUnicodeScalar(of: self)
	}
	
	var hasIotaSubscript: Bool {
		return CharacterSet.greekLettersWithIotaSubscript.containsUnicodeScalar(of: self)
	}
}

