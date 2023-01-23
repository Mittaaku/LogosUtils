//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension String {

    var characters: [Character] {
        return Array(self)
    }

    var nonBlank: Self? {
        return isBlank ? nil : self
    }
}

// MARK: - Evaluating Properties
public extension String {
	
	/// LogosUtils: Checks that the string is not empty and does not contain only whitespace.
	///
	///     ".".isBlank -> false
	///     " ".isBlank -> true
	///     "".isBlank -> true
	var isBlank: Bool {
		return NSRegularExpression.whitespaceOrEmptyStringPattern.matches(string: self)
	}
	
	/// LogosUtils: Inverse of .isBlank.
	///
	///     ".".isNotBlank -> true
	///     " ".isNotBlank -> false
	///     "".isNotBlank -> false
	var isNotBlank: Bool {
		return !isBlank
	}
}

// MARK: - Language Properties
public extension String {
	/// LogosUtils: Check whether the string consists of Greek characters.
	var isSpacedGreek: Bool {
		return NSRegularExpression.spacedGreekPattern.matches(string: self)
	}
	
	/// LogosUtils: Check whether the string consists of Greek characters.
	var isGreek: Bool {
		return NSRegularExpression.greekPattern.matches(string: self)
	}
	
	/// LogosUtils: Check whether the string consists of Hebrew characters.
	var isSpacedHebrew: Bool {
		return NSRegularExpression.spacedHebrewPattern.matches(string: self)
	}
	
	/// LogosUtils: Check whether the string consists of Hebrew characters.
	var isHebrew: Bool {
		return NSRegularExpression.hebrewPattern.matches(string: self)
	}
	
	/// LogosUtils: Returns the latin transliteration of a greek string.
	var greekTransliteration: String? {
		return applyingTransform(.latinToGreek, reverse: true)?.lowercased()
	}
	
	/// LogosUtils: Returns the latin transliteration of a hebrew string.
	var hebrewTransliteration: String? {
		return applyingTransform(.latinToHebrew, reverse: true)?.lowercased()
	}
}

// MARK: - Methods
public extension String {
	
	/// LogosUtils: Convert camel case to capitalized case separated by spaces.
	/// Credit: https://stackoverflow.com/questions/41292671/separating-camelcase-string-into-space-separated-words-in-swift
	var camelCaseToCapitalized: String {
		return self
			.replacingOccurrences(of: "([A-Z])",
								  with: " $1",
								  options: .regularExpression,
								  range: range(of: self))
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.capitalized // If input is in llamaCase
	}

	/// LogosUtils: Check whether the String contains the Diacritic.
	func contains(diacritic: Diacritic) -> Bool {
		return contains(unicodeScalarValue: diacritic.rawValue)
	}
	
	/// LogosUtils: Check whether the String contains the Unicode Scalar value.
	func contains(unicodeScalarValue: UInt32, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		let converted = form.convert(string: self)
		return converted.unicodeScalars.first { $0.value == unicodeScalarValue } != nil
	}
	
    /// LogosUtils: Check whether the String contains one or more of the characters in the input CharacterSet.
    func contains(characterFromSet set: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		let converted = form.convert(string: self)
        return converted.rangeOfCharacter(from: set, options: .literal, range: nil) != nil
    }

    /// LogosUtils: Check whether the String consists of (only contains) the characters in the input CharacterSet.
    func consists(ofCharactersFromSet set: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		let converted = form.convert(string: self)
        return set.isSuperset(of: CharacterSet(charactersIn: converted))
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
	
	@available(iOS 15.0, macOS 13.0, *)
	func splitByAndRetrain(separator regex: Regex<Substring>) -> [(split: String, separator: String?)]? {
		let matches = self.matches(of: regex)
		var result = [(String, String?)]()
		var startIndex = self.startIndex
		for match in matches {
			let splitter = self[match.range.lowerBound ..< match.range.upperBound]
			let split = self[startIndex ..< match.range.lowerBound]
			result.append((String(split), String(splitter)))
			startIndex = match.range.upperBound
		}
		let finalString = String(self[startIndex...])
		if !finalString.isEmpty {
			result.append((finalString, nil))
		}
		return result
	}

    func strippingDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
	
	func strippingCharacters(in set: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping, resultingForm: UnicodeNormalizationForm = .precomposedWithCanonicalMapping) -> String {
		let converted = form.convert(string: self)
		let filtered = converted.unicodeScalars.filter { !set.contains($0) }
		let new = String(String.UnicodeScalarView(filtered))
		return form.convert(string: new)
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
