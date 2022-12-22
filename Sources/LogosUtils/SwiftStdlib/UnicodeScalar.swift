//
//  UnicodeScalar.swift
//  
//
//  Created by Tom-Roger Mittag on 22/12/2022.
//

import Foundation

public extension UnicodeScalar {
	
	var hasAcute: Bool {
		return CharacterSet.greekLettersWithAcute.containsPrecomposedUnicodeScalar(of: self)
	}
	
	var hasGrave: Bool {
		return CharacterSet.greekLettersWithGrave.containsPrecomposedUnicodeScalar(of: self)
	}
	
	var hasSmoothBreathing: Bool {
		return CharacterSet.greekLettersWithSmoothBreathing.containsPrecomposedUnicodeScalar(of: self)
	}
	
	var hasRoughBreathing: Bool {
		return CharacterSet.greekLettersWithRoughBreathing.containsPrecomposedUnicodeScalar(of: self)
	}
	
	var hasCircumflex: Bool {
		return CharacterSet.greekLettersWithCircumflex.containsPrecomposedUnicodeScalar(of: self)
	}
	
	var hasIotaSubscript: Bool {
		return CharacterSet.greekLettersWithIotaSubscript.containsPrecomposedUnicodeScalar(of: self)
	}
}
