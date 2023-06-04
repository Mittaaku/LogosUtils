import Foundation
import XCTest
@testable import LogosUtils


final class StringExtensionsTests: XCTestCase {

	func testContainsCharacterFromSet() {
		XCTAssertTrue("Hello".contains(characterFromSet: .letters))
		XCTAssertFalse("12345".contains(characterFromSet: .letters))
	}
	
	func testContainsDiacritic() {
		XCTAssertTrue("café".contains(diacritic: .acute))
		XCTAssertFalse("cafe".contains(diacritic: .acute))
	}
	
	func testContainsUnicodeScalarValue() {
		XCTAssertTrue("Hello".contains(unicodeScalarValue: 72)) // 'H'
		XCTAssertFalse("Hello".contains(unicodeScalarValue: 74)) // 'J'
	}
	
	func testConsistsOfCharactersFromSet() {
		XCTAssertTrue("12345".consists(ofCharactersFromSet: .decimalDigits))
		XCTAssertFalse("Hello123".consists(ofCharactersFromSet: .letters))
	}
	
	func testConsistsOfDigits() {
		XCTAssertTrue("12345".consistsOfDigits)
		XCTAssertFalse("Hello123".consistsOfDigits)
	}
	
	func testConsistsOfGreek() {
		XCTAssertTrue("Γειά".consistsOfGreek)
		XCTAssertFalse("Hello123".consistsOfGreek)
	}
	
	func testConsistsOfGreekWithWhitespace() {
		XCTAssertTrue("Γειά σας".consistsOfGreekWithWhitespace)
		XCTAssertFalse("Hello 123".consistsOfGreekWithWhitespace)
	}
	
	func testConsistsOfLatin() {
		XCTAssertTrue("Hello".consistsOfLatin)
		XCTAssertFalse("Γειά σας".consistsOfLatin)
	}
	
	func testConsistsOfLatinWithWhitespace() {
		XCTAssertTrue("Hello".consistsOfLatinWithWhitespace)
		XCTAssertFalse("Γειά σας".consistsOfLatinWithWhitespace)
	}
	
	func testConsistsOfHebrew() {
		XCTAssertTrue("שלום".consistsOfHebrew)
		XCTAssertFalse("Hello".consistsOfHebrew)
	}
	
	func testConsistsOfHebrewWithWhitespace() {
		XCTAssertTrue("שלום ".consistsOfHebrewWithWhitespace)
		XCTAssertFalse("Hello".consistsOfHebrewWithWhitespace)
	}
	
	func testConsistsOfWhitespace() {
		XCTAssertTrue("   ".consistsOfWhitespace)
		XCTAssertFalse("Hello".consistsOfWhitespace)
	}
	
	func testIsBlank() {
		XCTAssertTrue("   ".isBlank)
		XCTAssertFalse("Hello".isBlank)
	}
	
	func testIsCamelCase() {
		XCTAssertTrue("camelCase".isCamelCase)
		XCTAssertTrue("anotherCamelCaseExample".isCamelCase)
		XCTAssertTrue("single".isCamelCase)
		XCTAssertTrue("c".isCamelCase)
		
		XCTAssertFalse("CamelCase".isCamelCase)
		XCTAssertFalse("camel Case".isCamelCase)
		XCTAssertFalse("camel_Case".isCamelCase)
		XCTAssertFalse("9595".isCamelCase)
		XCTAssertFalse("a9".isCamelCase)
		XCTAssertFalse("".isCamelCase)
	}
	
	func testCamelCaseToCapitalized() {
		XCTAssertEqual("helloWorld".camelCaseToCapitalized, "Hello World")
		XCTAssertEqual("helloWorldTest".camelCaseToCapitalized, "Hello World Test")
		XCTAssertEqual("HelloWorld".camelCaseToCapitalized, "Hello World")
	}
	
	func testHTMLToMarkdown() {
		let html = "<p>This is a <strong>paragraph</strong> with a <a href=\"https://example.com\">link</a>.</p>"
		let expectedMarkdown = "This is a **paragraph** with a [link](https://example.com).\n\n"
		
		XCTAssertEqual(html.htmlToMarkdown, expectedMarkdown)
	}
	
	func testLowercasedRange() {
		let string = "Hello World"
		XCTAssertEqual(string.lowercased(range: string.startIndex..<"HELLO".endIndex), "hello World")
	}
	
	func testUppercasedRange() {
		let string = "Hello World"
		XCTAssertEqual(string.uppercased(range: string.startIndex..<"Hello".endIndex), "HELLO World")
	}
	
	func testCleaned() {
		// Test with whitespace and newlines
		let dirtyString1 = "   Hello, World!   \n"
		let cleanedString1 = dirtyString1.cleaned
		XCTAssertEqual(cleanedString1, "Hello, World!")
		
		// Test with empty string
		let dirtyString2 = ""
		let cleanedString2 = dirtyString2.cleaned
		XCTAssertNil(cleanedString2)
	}
	
	func testExtractInitials() {
		// Test case 1: Valid string with initials
		XCTAssertEqual("John Doe".extractInitials(), "JD")
		
		// Test case 2: Valid string with multiple initials
		XCTAssertEqual("Jane Ann Smith".extractInitials(), "JAS")
		
		// Test case 3: Valid string with initials and numbers
		XCTAssertEqual("Peter Parker 42".extractInitials(), "PP")
		
		// Test case 4: Valid string with initials and underscores
		XCTAssertEqual("Alice_Bob_Charlie".extractInitials(), "ABC")
		
		// Test case 5: Valid string with mixed case initials
		XCTAssertEqual("johnDoe".extractInitials(), "jD")
		
		// Test case 6: Valid string with single letter initials
		XCTAssertEqual("A B C".extractInitials(), "ABC")
		
		// Test case 7: Invalid string with no initials
		XCTAssertEqual("123456".extractInitials(), "")
	}
	
	func testExtractAndRemoveFirst() {
		// Test with non-empty string
		var string1 = "Hello, World!"
		let extracted1 = string1.extractAndRemoveFirst(5)
		XCTAssertEqual(extracted1, "Hello")
		XCTAssertEqual(string1, ", World!")
	}
	
	func testExtractAndRemoveLast() {
		// Test with non-empty string
		var string1 = "Hello, World!"
		let extracted1 = string1.extractAndRemoveLast(6)
		XCTAssertEqual(extracted1, "World!")
		XCTAssertEqual(string1, "Hello, ")
	}
	
	func testFilterUsingRegex() {
		// Test with matching substrings
		let string1 = "abc123def456ghi789"
		let regex1 = try! NSRegularExpression(pattern: "[0-9]+", options: [])
		let filtered1 = string1.filter(using: regex1)
		XCTAssertEqual(filtered1, "123456789")
		
		// Test with no matching substrings
		let string2 = "abcxyz"
		let regex2 = try! NSRegularExpression(pattern: "[0-9]+", options: [])
		let filtered2 = string2.filter(using: regex2)
		XCTAssertEqual(filtered2, "")
	}
	
	func testNonBlankString() {
		// Test with non-empty string
		let string1 = "Hello, World!"
		let nonBlankString1 = string1.nonBlank
		XCTAssertEqual(nonBlankString1, "Hello, World!")
		
		// Test with empty string
		let string2 = ""
		let nonBlankString2 = string2.nonBlank
		XCTAssertNil(nonBlankString2)
		
		// Test with whitespace characters
		let string3 = "     \t\n"
		let nonBlankString3 = string3.nonBlank
		XCTAssertNil(nonBlankString3)
	}
	
	func testSplitByRegex() {
		let text = "Hello, World! This is a sample text."
		
		// Test splitting by non-word characters
		let regex1 = try! NSRegularExpression(pattern: "\\W+")
		let expected1: [String.SubSequence] = ["Hello", "World", "This", "is", "a", "sample", "text"]
		XCTAssertEqual(text.split(separator: regex1), expected1)
		
		// Test splitting by spaces
		let regex2 = try! NSRegularExpression(pattern: " ")
		let expected2: [String.SubSequence] = ["Hello,", "World!", "This", "is", "a", "sample", "text."]
		XCTAssertEqual(text.split(separator: regex2), expected2)
	}
	
	func testSplitByAndRetrain() {
		
		func isEqual(_ tupleArray1: [(leadingSeparator: String?, content: String, trailingSeparator: String?)], _ tupleArray2: [(leadingSeparator: String?, content: String, trailingSeparator: String?)]) {
			let zipped = zip(tupleArray1, tupleArray2)
			for pair in zipped {
				XCTAssertEqual(pair.0.leadingSeparator, pair.1.leadingSeparator)
				XCTAssertEqual(pair.0.content, pair.1.content)
				XCTAssertEqual(pair.0.trailingSeparator, pair.1.trailingSeparator)
			}
		}
		
		let input = "Hello, World!"
		
		// Test with separator ","
		let separator = try! NSRegularExpression(pattern: ", ")
		let expectedResult: [(leadingSeparator: String?, content: String, trailingSeparator: String?)] = [
			(leadingSeparator: nil, content: "Hello", trailingSeparator: ", "),
			(leadingSeparator: ", ", content: "World!", trailingSeparator: nil)
		]
		let result = input.splitByAndRetrain(separator: separator)
		isEqual(result, expectedResult)
		
		// Test with separator "o"
		let separator2 = try! NSRegularExpression(pattern: "o")
		let expectedResult2: [(leadingSeparator: String?, content: String, trailingSeparator: String?)] = [
			(leadingSeparator: nil, content: "Hell", trailingSeparator: "o"),
			(leadingSeparator: "o", content: ", W", trailingSeparator: "o"),
			(leadingSeparator: "o", content: "rld!", trailingSeparator: nil)
		]
		let result2 = input.splitByAndRetrain(separator: separator2)
		isEqual(result2, expectedResult2)
	}
	
	func testStrippingDiacritics() {
		// Test case with diacritic marks
		let stringWithDiacritics = "Héllò Wórld"
		let expectedResult = "Hello World"
		XCTAssertEqual(stringWithDiacritics.strippingDiacritics, expectedResult)
		
		// Test case without diacritic marks
		let stringWithoutDiacritics = "Hello World"
		XCTAssertEqual(stringWithoutDiacritics.strippingDiacritics, stringWithoutDiacritics)
		
		// Test case with multiple diacritic marks
		let stringWithMultipleDiacritics = "Åpple Jümped Øver Öther Früits"
		let expectedMultipleDiacriticsResult = "Apple Jumped Øver Other Fruits"
		XCTAssertEqual(stringWithMultipleDiacritics.strippingDiacritics, expectedMultipleDiacriticsResult)
		
		// Test case with empty string
		let emptyString = ""
		XCTAssertEqual(emptyString.strippingDiacritics, emptyString)
	}
}
