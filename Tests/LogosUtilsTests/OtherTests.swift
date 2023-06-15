//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 16/11/2022.
//

import XCTest
@testable import LogosUtils

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
