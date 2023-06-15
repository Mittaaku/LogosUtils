//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

// MARK: - Evaluation

public extension String {
	
	/// Checks if the string contains any character from a given character set.
	/// - Parameters:
	///   - set: The character set to check.
	///   - form: The Unicode normalization form to apply (default is `.decomposedWithCanonicalMapping`).
	/// - Returns: `true` if the string contains any character from the character set, `false` otherwise.
	func contains(characterFromSet set: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		let converted = form.convert(string: self)
		return converted.rangeOfCharacter(from: set, options: .literal, range: nil) != nil
	}
	
	/// Checks if the string contains a specific diacritic.
	/// - Parameter diacritic: The diacritic to check.
	/// - Returns: `true` if the string contains the diacritic, `false` otherwise.
	func contains(diacritic: Diacritic) -> Bool {
		return contains(unicodeScalarValue: diacritic.rawValue)
	}
	
	/// Checks if the string contains a Unicode scalar value.
	/// - Parameters:
	///   - unicodeScalarValue: The Unicode scalar value to check.
	///   - form: The Unicode normalization form to apply (default is `.decomposedWithCanonicalMapping`).
	/// - Returns: `true` if the string contains the Unicode scalar value, `false` otherwise.
	func contains(unicodeScalarValue: UInt32, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		let converted = form.convert(string: self)
		return converted.unicodeScalars.first { $0.value == unicodeScalarValue } != nil
	}
	
	/// Checks if the string consists only of characters from a given character set.
	/// - Parameters:
	///   - set: The character set to check.
	///   - form: The Unicode normalization form to apply (default is `.decomposedWithCanonicalMapping`).
	/// - Returns: `true` if the string consists only of characters from the character set, `false` otherwise.
	func consists(ofCharactersFromSet set: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping) -> Bool {
		let converted = form.convert(string: self)
		return set.isSuperset(of: CharacterSet(charactersIn: converted))
	}
	
	/// Checks if the string is empty or contains only whitespace characters.
	var isBlank: Bool {
		return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
}

// MARK: - Regular Expression Evaluation

public extension String {
	
	// Regular expressions as static variables
	private static let camelCaseRegex = try! NSRegularExpression(pattern: "^[a-z]+(?:[A-Z][a-z]*)*$")
	private static let digitsRegex = try! NSRegularExpression(pattern: #"^\d+$"#)
	private static let greekRegex = try! NSRegularExpression(pattern: #"^\p{script=Greek}+$"#)
	private static let greekWithWhitespaceRegex = try! NSRegularExpression(pattern: #"^[\s\p{script=Greek}]+$"#)
	private static let hebrewRegex = try! NSRegularExpression(pattern: #"^\p{script=Hebrew}+$"#)
	private static let hebrewWithWhitespaceRegex = try! NSRegularExpression(pattern: #"^[\s\p{script=Hebrew}]+$"#)
	private static let latinRegex = try! NSRegularExpression(pattern: #"^\p{script=Latin}+$"#)
	private static let latinWithWhitespaceRegex = try! NSRegularExpression(pattern: #"^[\s\p{script=Latin}]+$"#)
	private static let whitespaceRegex = try! NSRegularExpression(pattern: #"^\s+$"#)
	
	/// Returns a Boolean value indicating whether the string is in camelCase format.
	var isCamelCase: Bool {
		return Self.camelCaseRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of digits characters.
	var consistsOfDigits: Bool {
		return Self.digitsRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of Greek characters.
	var consistsOfGreek: Bool {
		return Self.greekRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of Greek characters and whitespace.
	var consistsOfGreekWithWhitespace: Bool {
		return Self.greekWithWhitespaceRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of Hebrew characters.
	var consistsOfHebrew: Bool {
		return Self.hebrewRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of Hebrew characters and whitespace.
	var consistsOfHebrewWithWhitespace: Bool {
		return Self.hebrewWithWhitespaceRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of Latin characters.
	var consistsOfLatin: Bool {
		return Self.latinRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of Latin characters and whitespace.
	var consistsOfLatinWithWhitespace: Bool {
		return Self.latinWithWhitespaceRegex ~= self
	}
	
	/// Returns a Boolean value indicating whether the string consists only of whitespace characters.
	var consistsOfWhitespace: Bool {
		return Self.whitespaceRegex ~= self
	}
}

// MARK: - General Character Conversion

public extension String {
	
	/// Converts a camelCase string to capitalized words.
	/// Returns the converted string.
	var camelCaseToCapitalized: String {
		return self
			.replacingOccurrences(of: "([A-Z])",
								  with: " $1",
								  options: .regularExpression,
								  range: range(of: self))
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.capitalized // If input is in llamaCase
	}
	
	/// Converts HTML to Markdown.
	var htmlToMarkdown: String {
		var markdown = self
		
		let tagMappings: [(String, String)] = [
			("<h1>(.*?)</h1>", "# $1\n"),
			("<h2>(.*?)</h2>", "## $1\n"),
			("<h3>(.*?)</h3>", "### $1\n"),
			("<h4>(.*?)</h4>", "#### $1\n"),
			("<h5>(.*?)</h5>", "##### $1\n"),
			("<h6>(.*?)</h6>", "###### $1\n"),
			("<p>(.*?)</p>", "$1\n\n"),
			("<em>(.*?)</em>|<i>(.*?)</i>", "_$1$2_"),
			("<strong>(.*?)</strong>|<b>(.*?)</b>", "**$1$2**"),
			("<a\\s+href=\"([^\"]+)\"[^>]*>(.*?)</a>", "[$2]($1)"),
			("<ul>(.*?)</ul>", "$1"),
			("<ol>(.*?)</ol>", "$1"),
			("<li>(.*?)</li>", "- $1\n")
		]
		
		for (pattern, replacement) in tagMappings {
			let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
			markdown = regex.stringByReplacingMatches(
				in: markdown,
				options: [],
				range: NSRange(location: 0, length: markdown.utf16.count),
				withTemplate: replacement
			)
		}
		
		// Remove remaining HTML tags
		markdown = markdown.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
		
		return markdown
	}
	
	/// Converts a range of characters in the string to lowercase.
	/// - Parameter range: The range of characters to convert.
	/// - Returns: The string with the specified range of characters converted to lowercase.
	func lowercased(range: Range<String.Index>) -> String {
		return replacingCharacters(in: range.lowerBound ..< range.upperBound, with: self[range].lowercased())
	}
	
	/// Converts a range of characters in the string to uppercase.
	/// - Parameter range: The range of characters to convert.
	/// - Returns: The string with the specified range of characters converted to uppercase.
	func uppercased(range: Range<String.Index>) -> String {
		return replacingCharacters(in: range.lowerBound ..< range.upperBound, with: self[range].uppercased())
	}
}

// MARK: - Script Conversions

public extension String {
	
	/// Returns the string converted from Arabic characters to Latin characters, if possible.
	var arabicToLatin: String? {
		return applyingTransform(.latinToArabic, reverse: true)?.lowercased()
	}
	
	/// Returns the string converted from Cyrillic characters to Latin characters, if possible.
	var cyrillicToLatin: String? {
		return applyingTransform(.latinToCyrillic, reverse: true)?.lowercased()
	}
	
	/// Returns the string converted from Greek characters to Latin characters, if possible.
	var greekToLatin: String? {
		return applyingTransform(.latinToGreek, reverse: true)?.lowercased()
	}
	
	/// Returns the string converted from Hebrew characters to Latin characters, if possible.
	var hebrewToLatin: String? {
		return applyingTransform(.latinToHebrew, reverse: true)?.lowercased()
	}
	
	/// Returns the string converted from Hiragana/Katakana characters to Latin characters, if possible.
	var kanaToLatin: String? {
		let latin = applyingTransform(.latinToHiragana, reverse: true) ?? applyingTransform(.latinToKatakana, reverse: true)
		return latin?.lowercased()
	}
	
	/// Returns the string converted from Latin characters to Arabic characters, if possible.
	var latinToArabic: String? {
		return applyingTransform(.latinToArabic, reverse: false)
	}
	
	/// Returns the string converted from Latin characters to Cyrillic characters, if possible.
	var latinToCyrillic: String? {
		return applyingTransform(.latinToCyrillic, reverse: false)
	}
	
	/// Returns the string converted from Latin characters to Greek characters, if possible.
	var latinToGreek: String? {
		return applyingTransform(.latinToGreek, reverse: false)
	}
	
	/// Returns the string converted from Latin characters to Hebrew characters, if possible.
	var latinToHebrew: String? {
		return applyingTransform(.latinToHebrew, reverse: false)
	}
	
	/// Returns the string converted from Latin characters to Hiragana characters, if possible.
	var latinToHiragana: String? {
		return applyingTransform(.latinToHiragana, reverse: false)
	}
	
	/// Returns the string converted from Latin characters to Katakana characters, if possible.
	var latinToKatakana: String? {
		return applyingTransform(.latinToKatakana, reverse: false)
	}
}

// MARK: - Other

public extension String {
	
	/// A cleaned version of the string by trimming leading and trailing whitespaces and newlines, and, if the trimmed string is not empty, performing Unicode normalization
	var cleaned: String? {
		/// The string with leading and trailing whitespace and newlines removed.
		let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
		
		// If the trimmed string is empty, return `nil`
		guard !trimmed.isEmpty else {
			return nil
		}
		
		// Return the trimmed string after performing Unicode normalization
		return trimmed.precomposedStringWithCompatibilityMapping
	}
	
	/// Extracts initials from a given string.
	///
	/// - Returns: A new string containing the extracted initials.
	func extractInitials() -> String {
		var result = ""
		let words = self.components(separatedBy: CharacterSet(charactersIn: " _-"))
		for word in words {
			var iterator = word.makeIterator()
			guard let first = iterator.next(), first.isLetter else{
				continue
			}
			result.append(first)
			while let next = iterator.next() {
				if next.isUppercase {
					result.append(next)
				}
			}
		}
		return result
	}

	/// Extracts and removes the first `k` characters from the string.
	/// - Parameter k: The number of characters to extract.
	/// - Returns: The extracted substring.
	mutating func extractAndRemoveFirst(_ k: Int) -> String {
		let result = String(prefix(k))
		removeFirst(k)
		return result
	}
	
	/// Extracts and removes the last `k` characters from the string.
	/// - Parameter k: The number of characters to extract.
	/// - Returns: The extracted substring.
	mutating func extractAndRemoveLast(_ k: Int) -> String {
		let result = String(suffix(k))
		removeLast(k)
		return result
	}
	
	/// Filters the string using the provided regular expression.
	///
	/// - Parameters:
	///   - regex: The regular expression to be used for filtering.
	/// - Returns: A new string containing only the substrings that match the given regular expression.
	func filter(using regex: NSRegularExpression) -> String {
		var result = ""
		
		// Create an NSRange representing the entire string
		let range = NSRange(location: 0, length: self.utf16.count)
		
		// Enumerate all matches using the provided regular expression
		regex.enumerateMatches(in: self, options: [], range: range) { (match, _, _) in
			if let matchRange = match?.range, let swiftRange = Range(matchRange, in: self) {
				// Extract the matched substring and append it to the result
				result += String(self[swiftRange])
			}
		}
		
		// Return the final filtered string
		return result
	}
	
	/// Filters the string using the provided `RegexComponent`.
	///
	/// - Parameters:
	///   - regex: The regular expression to be used for filtering.
	/// - Returns: A new string containing only the substrings that match the given regular expression.
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
	
	/// Returns the string itself if it is not empty or contains only whitespace characters.
	/// Otherwise, returns nil.
	var nonBlank: Self? {
		return isBlank ? nil : self
	}
	
	/// Sanitizes the string for use as a file name by removing invalid characters.
	///
	/// - Returns: A sanitized version of the string without any invalid characters.
	func sanitizedForFileName() -> String {
		let sanitizedString = self.components(separatedBy: CharacterSet.invalidFileNameCharacters).joined(separator: "")
		return sanitizedString
	}

	/// Splits a string based on the provided regular expression.
	///
	/// - Parameters:
	///   - separator: The regular expression used to split the string.
	///   - deleteEmpty: A boolean flag indicating whether empty strings should be deleted from the result. Default is `false`.
	/// - Returns: An array of `String.SubSequence` representing the split parts of the string.
	func split(separator: NSRegularExpression, omittingEmptySubsequences: Bool = true) -> [String.SubSequence] {
		let range = NSRange(location: 0, length: self.utf16.count)
		let matches = separator.matches(in: self, range: range)
		
		var result: [String.SubSequence] = []
		
		var previousIndex = self.startIndex
		for match in matches {
			let startIndex = self.index(self.startIndex, offsetBy: match.range.location)
			let endIndex = self.index(startIndex, offsetBy: match.range.length)
			let range = startIndex..<endIndex
			
			let substring = self[previousIndex..<range.lowerBound]
			
			if !omittingEmptySubsequences || !substring.isEmpty {
				result.append(substring)
			}
			
			previousIndex = range.upperBound
		}
		
		let lastSubstring = self[previousIndex..<self.endIndex]
		
		if !omittingEmptySubsequences || !lastSubstring.isEmpty {
			result.append(lastSubstring)
		}
		
		return result
	}
	
	/// Splits the string into segments based on the provided regular expression separator and returns an array of tuples representing each segment.
	///
	/// - Parameters:
	///   - separator: The regular expression used to split the string.
	/// - Returns: An array of tuples representing each segment of the string.
	func splitByAndRetrain(separator regex: NSRegularExpression) -> [(leadingSeparator: String?, content: String, trailingSeparator: String?)] {
		/// Find all matches of the regular expression in the string.
		let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
		
		var result = [(String?, String, String?)]() // Array to store the segments
		var startIndex = self.startIndex // Starting index of the current segment
		var leadingSeparator: String? = nil // Leading separator of the current segment
		
		for match in matches {
			let trailingSeparator = String(self[Range(match.range, in: self)!]) // Extract the trailing separator of the current segment
			let content = String(self[startIndex ..< Range(match.range, in: self)!.lowerBound]) // Extract the content of the current segment
			result.append((leadingSeparator, content, trailingSeparator)) // Append the segment tuple to the result array
			startIndex = Range(match.range, in: self)!.upperBound // Update the starting index to the end of the current segment
			leadingSeparator = trailingSeparator // Update the leading separator for the next segment
		}
		
		let finalString = String(self[startIndex...]) // Extract the remaining string after the last match
		if !finalString.isEmpty {
			result.append((leadingSeparator, finalString, nil)) // Append the remaining string as the last segment
		}
		
		return result
	}
	
	/// Splits the string into segments based on the provided `Regex<Substring>` and returns an array of tuples representing each segment.
	///
	/// - Parameters:
	///   - separator: The regular expression used to split the string.
	/// - Returns: An array of tuples representing each segment of the string.
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
	
	/// Removes characters from the string that are present in a given character set.
	/// - Parameters:
	///   - set: The character set to remove.
	///   - form: The Unicode normalization form to apply (default is `.decomposedWithCanonicalMapping`).
	///   - resultingForm: The Unicode normalization form of the resulting string (default is `.precomposedWithCanonicalMapping`).
	/// - Returns: The string with specified characters removed.
	func strippingCharacters(in set: CharacterSet, inForm form: UnicodeNormalizationForm = .decomposedWithCanonicalMapping, resultingForm: UnicodeNormalizationForm = .precomposedWithCanonicalMapping) -> String {
		let converted = form.convert(string: self)
		let filtered = converted.unicodeScalars.filter { !set.contains($0) }
		let new = String(String.UnicodeScalarView(filtered))
		return form.convert(string: new)
	}
	
	/// Removes diacritic marks from the string.
	/// - Returns: The string with diacritics removed.
	var strippingDiacritics: String {
		return self.folding(options: .diacriticInsensitive, locale: .current)
	}
}
#endif
