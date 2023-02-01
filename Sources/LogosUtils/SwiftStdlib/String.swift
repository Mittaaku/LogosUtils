//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Static Regex Pattern Variables
@available(iOS 16.0, macOS 13.0, *)
public extension String {
	static var digitStringPattern = try! Regex(#"^\d+$"#)
	static var whitespaceStringPattern = try! Regex(#"^\s+$"#)
	static var whitespaceOrEmptyStringPattern = try! Regex(#"^\s*$"#)
	
	static var spacedGreekPattern = try! Regex(#"^[\p{script=Greek}\s]+$"#)
	static var greekPattern = try! Regex(#"^[\p{script=Greek}]+$"#)
	
	static var spacedHebrewPattern = try! Regex(#"^[\p{script=Hebrew}\s]+$"#)
	static var hebrewPattern = try! Regex(#"^[\p{script=Hebrew}]+$"#)
}

// MARK: - Properties
public extension String {
	
	/// LogosUtils: Checks that the string is not empty and does not contain only whitespace.
	///
	///     ".".isBlank -> false
	///     " ".isBlank -> true
	///     "".isBlank -> true
	@available(iOS 16.0, macOS 13.0, *)
	var isBlank: Bool {
		return starts(with: String.whitespaceOrEmptyStringPattern)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	var nonBlank: Self? {
		return isBlank ? nil : self
	}
}

// MARK: - Language Properties
public extension String {
	/// LogosUtils: Check whether the string consists of Greek characters and whitespace.
	@available(iOS 16.0, macOS 13.0, *)
	var isSpacedGreek: Bool {
		return String.spacedGreekPattern ~= self
	}
	
	/// LogosUtils: Check whether the string consists of only Greek characters without whitespace.
	@available(iOS 16.0, macOS 13.0, *)
	var isGreek: Bool {
		return String.greekPattern ~= self
	}
	
	/// LogosUtils: Check whether the string consists of Hebrew characters and whitespace.
	@available(iOS 16.0, macOS 13.0, *)
	var isSpacedHebrew: Bool {
		return String.spacedHebrewPattern ~= self
	}
	
	/// LogosUtils: Check whether the string consists of only Hebrew characters without whitespace.
	@available(iOS 16.0, macOS 13.0, *)
	var isHebrew: Bool {
		return String.hebrewPattern ~= self
	}
	
	/// LogosUtils: Returns the latin transliteration of a greek string.
	var latinizeGreek: String? {
		return applyingTransform(.latinToGreek, reverse: true)?.lowercased()
	}
	
	/// LogosUtils: Returns the latin transliteration of a hebrew string.
	var latinizeHebrew: String? {
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
	
	@available(iOS 16.0, macOS 13.0, *)
	func filter(using regex: any RegexComponent) -> String {
		var result = ""
		for range in ranges(of: regex) {
			guard !range.isEmpty else {
				continue
			}
			result += self[range]
		}
		return result
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func splitByAndRetrain(separator regex: Regex<Substring>) -> [(leadingSeparator: String?, content: String, trailingSeparator: String?)] {
		let matches = self.matches(of: regex)
		var result = [(String?, String, String?)]()
		var startIndex = self.startIndex
		var leadingSeparator: String? = nil
		
		for match in matches {
			let trailingSeparator = String(self[match.range.lowerBound ..< match.range.upperBound])
			let content = String(self[startIndex ..< match.range.lowerBound])
			result.append((leadingSeparator, content, trailingSeparator))
			startIndex = match.range.upperBound
			leadingSeparator = trailingSeparator
		}
		let finalString = String(self[startIndex...])
		if !finalString.isEmpty {
			result.append((leadingSeparator, finalString, nil))
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
