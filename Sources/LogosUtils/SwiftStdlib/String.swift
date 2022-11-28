//
//  String.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/13/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension String {

    var characters: [Character] {
        return Array(self)
    }
	
	/// LogosUtils: Get Int from String (if initializable).
	///
	///		"10".int -> 10
	///
	var int: Int? {
		return Int(self)
	}

    var nonBlank: Self? {
        return isBlank ? nil : self
    }
}

// MARK: - Evaluating Properties
public extension String {
#if canImport(Foundation)
	/// LogosUtils: Checks that the string is not empty and does not contain only whitespace.
	///
	///     ".".isBlank -> false
	///     " ".isBlank -> true
	///     "".isBlank -> true
	var isBlank: Bool {
		return NSRegularExpression.whitespaceOrEmptyStringPattern.matches(string: self)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Inverse of .isBlank.
	///
	///     ".".isNotBlank -> true
	///     " ".isNotBlank -> false
	///     "".isNotBlank -> false
	var isNotBlank: Bool {
		return !isBlank
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Check whether the string consists of Greek only.
	///
	///     "123".isDigits -> true
	///     "abc".isDigits -> false
	var isDigits: Bool {
		return NSRegularExpression.digitStringPattern.matches(string: self)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Check whether the string consists of Greek only.
	///
	///     ".".isBlank -> false
	///     " ".isBlank -> true
	///     "".isBlank -> false
	var isWhitespace: Bool {
		return NSRegularExpression.whitespaceStringPattern.matches(string: self)
	}
#endif
}

// MARK: - Language Properties
public extension String {
#if canImport(Foundation)
	/// LogosUtils: Check whether the string consists of Greek characters.
	var isSpacedGreek: Bool {
		return NSRegularExpression.spacedGreekPattern.matches(string: self)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Check whether the string consists of Greek characters.
	var isGreek: Bool {
		return NSRegularExpression.greekPattern.matches(string: self)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Check whether the string consists of Hebrew characters.
	var isSpacedHebrew: Bool {
		return NSRegularExpression.spacedHebrewPattern.matches(string: self)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Check whether the string consists of Hebrew characters.
	var isHebrew: Bool {
		return NSRegularExpression.hebrewPattern.matches(string: self)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Returns the latin transliteration of a greek string.
	var greekTransliteration: String? {
		return applyingTransform(.latinToGreek, reverse: true)?.lowercased()
	}
#endif

#if canImport(Foundation)
	/// LogosUtils: Returns the latin transliteration of a hebrew string.
	var hebrewTransliteration: String? {
		return applyingTransform(.latinToHebrew, reverse: true)?.lowercased()
	}
#endif
}

// MARK: - Methods
public extension String {

    /// LogosUtils: Check whether the String contains one or more of the characters in the input CharacterSet
    func contains(set: CharacterSet) -> Bool {
        return self.rangeOfCharacter(from: set, options: .literal, range: nil) != nil
    }

    /// LogosUtils: Check whether the String consists of (only contains) the characters in the input CharacterSet.
    func consists(ofSet set: CharacterSet) -> Bool {
        return set.isSuperset(of: CharacterSet(charactersIn: self))
    }

    mutating func extractFirst(_ k: Int) -> String {
        let result = String(prefix(k))
        removeFirst(k)
        return result
    }

    mutating func extractLast(_ k: Int) -> String {
        let result = String(suffix(k))
        removeLast(k)
        return result
    }

    func nonBlanked(or error: @autoclosure () -> Swift.Error) throws -> Self {
        guard let value = nonBlank else {
            throw error()
        }
        return value
    }

    func nonBlanked(or defaultValue: @autoclosure () -> Self) -> Self {
        return nonBlank ?? defaultValue()
    }

    func strippingDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
	
	func uppercased(range: Range<String.Index>) -> String {
		return replacingCharacters(in: range.lowerBound ..< range.upperBound, with: self[range].uppercased())
	}
	
	func lowercased(range: Range<String.Index>) -> String {
		return replacingCharacters(in: range.lowerBound ..< range.upperBound, with: self[range].lowercased())
	}
}

func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
    return rhs.matches(string: lhs)
}
