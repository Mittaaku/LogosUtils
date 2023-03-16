//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 16/11/2022.
//

import XCTest
@testable import LogosUtils

@available(iOS 13.0, macOS 12.3, *)
final class ReferenceTests: XCTestCase {
	
	let reference1 = VerseReference(book: 3, chapter: 1, verse: 2)
	let reference2 = VerseReference(book: 3, chapter: 1, verse: 4)
	let reference3 = VerseReference(book: 3, chapter: 2, verse: 1)
	let reference4 = VerseReference(book: 1, chapter: 2, verse: 1)
	var reference5 = TokenReference(book: 1, chapter: 2, verse: 3, token: 1)
	var reference6 = BookReference(book: 1)
	var reference7 = BookReference(book: 66)
	var reference8 = BookReference(book: 51)
	
	func testReferenceOffset() {
		XCTAssertEqual(reference1.offset(from: reference2), .differentVerse)
		XCTAssertEqual(reference2.offset(from: reference3), .differentChapter)
		XCTAssertEqual(reference3.offset(from: reference4), .differentBook)
		XCTAssertEqual(reference4.offset(from: reference4), .identical)
		
		XCTAssertEqual(reference4.bookNumber, 1)
		XCTAssertEqual(reference4.chapterNumber, 2)
		XCTAssertEqual(reference4.verseNumber, 1)
		
		XCTAssertEqual(reference4.bookId == reference5.bookId, true)
		XCTAssertEqual(reference4.chapterId == reference5.chapterId, true)
		XCTAssertEqual(reference4.verseId == reference5.verseId, false)
		
		let decimalValue = reference5.decimalValue
		XCTAssertEqual(decimalValue, 1002003001)
		let referenceFromDecimal = TokenReference(decimalValue: decimalValue)
		XCTAssertEqual(reference5, referenceFromDecimal)
		
		reference5.bookNumber += 1
		XCTAssertEqual(reference5.bookNumber, 2)
		
		reference5.chapterNumber += 1
		XCTAssertEqual(reference5.chapterNumber, 3)
		
		reference5.verseNumber += 1
		XCTAssertEqual(reference5.verseNumber, 4)
		
		reference5.tokenNumber += 1
		XCTAssertEqual(reference5.tokenNumber, 2)
		
		reference5.bookNumber += 1
		XCTAssertEqual(reference5.bookNumber, 3)
		
		XCTAssertEqual(reference1.description, "0x3010200")
		XCTAssertEqual(reference1.debugDescription, "(book: 3, chapter: 1, verse: 2)")
		XCTAssertEqual(reference1.indices, [3, 1, 2])
		XCTAssertEqual(reference8.indices, [51])
		
	}
}

final class SetTests: XCTestCase {
	
	func testSet() {
		let testingSet = [1, 2, 3]
		
		let combinations = testingSet.generateCombinations()
		XCTAssertEqual(combinations, [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]])
	}
}


final class CharacterTests: XCTestCase {
	
	func testContainsDiacritic() {
		
		// ᾳ
		XCTAssertTrue(Character("\u{1FB3}").contains(diacritic: .iotaSubscript))
		XCTAssertTrue(Character("\u{3B1}\u{345}").contains(diacritic: .iotaSubscript))
		
		// ᾁ
		XCTAssertTrue(Character("\u{1F81}").contains(diacritic: .iotaSubscript))
		XCTAssertTrue(Character("\u{3B1}\u{345}\u{314}").contains(diacritic: .iotaSubscript))
		
		// ἁ
		XCTAssertFalse(Character("\u{1F01}").contains(diacritic: .iotaSubscript))
		XCTAssertFalse(Character("\u{3B1}\u{314}").contains(diacritic: .iotaSubscript))
		
		// ◌̔
		XCTAssertFalse(Character("\u{314}").contains(diacritic: .iotaSubscript))
		
		// ◌ͅ
		XCTAssertTrue(Character("\u{345}").contains(diacritic: .iotaSubscript))
		
		// α
		XCTAssertFalse(Character("\u{3B1}").contains(diacritic: .iotaSubscript))
	}
	
	func testDecompositionContains() {
		XCTAssertTrue(Character("\u{1FB3}").contains(characterFromSet: .greekVowels)) // ᾳ
		XCTAssertFalse(Character("\u{1FB3}").contains(characterFromSet: .greekConsonants)) // ᾳ
		
		XCTAssertFalse(Character("\u{39E}").contains(characterFromSet: .greekVowels)) // Ξ
		XCTAssertTrue(Character("\u{39E}").contains(characterFromSet: .greekConsonants)) // Ξ
	}
}

final class UnicodeScalarTests: XCTestCase {
	
	func testContainsDiacritic() {
		
		// ᾳ
		XCTAssertTrue(UnicodeScalar("\u{1FB3}").contains(diacritic: .iotaSubscript))
		
		// ᾁ
		XCTAssertTrue(UnicodeScalar("\u{1F81}").contains(diacritic: .iotaSubscript))
		
		// ἁ
		XCTAssertFalse(UnicodeScalar("\u{1F01}").contains(diacritic: .iotaSubscript))
		
		// ◌̔
		XCTAssertFalse(UnicodeScalar("\u{314}").contains(diacritic: .iotaSubscript))
		
		// ◌ͅ
		XCTAssertTrue(UnicodeScalar("\u{345}").contains(diacritic: .iotaSubscript))
		
		// α
		XCTAssertFalse(UnicodeScalar("\u{3B1}").contains(diacritic: .iotaSubscript))
	}
	
	func testDecompositionContains() {
		XCTAssertTrue(UnicodeScalar("\u{1FB3}").contains(characterFromSet: .greekVowels)) // ᾳ
		XCTAssertFalse(UnicodeScalar("\u{1FB3}").contains(characterFromSet: .greekConsonants)) // ᾳ
		
		XCTAssertFalse(UnicodeScalar("\u{39E}").contains(characterFromSet: .greekVowels)) // Ξ
		XCTAssertTrue(UnicodeScalar("\u{39E}").contains(characterFromSet: .greekConsonants)) // Ξ
	}
}

final class MiscTests: XCTestCase {
	
	func testCollections() {
		var arrayTesting = [1, 2, 4]
		XCTAssertTrue(arrayTesting.appendIfNoneEquates(3).appended)
		XCTAssertFalse(arrayTesting.appendIfNoneEquates(3).appended)
		XCTAssertTrue(arrayTesting.appendIfNotNil(1))
		XCTAssertFalse(arrayTesting.appendIfNotNil(nil))
		
		var setTesting = Set([1, 2, 6])
		XCTAssertTrue(setTesting.insertIfNotNil(1))
		XCTAssertFalse(setTesting.insertIfNotNil(nil))
	}
	
	func testExponent() {
		XCTAssertEqual(pow(4, 2), 16)
	}
}
