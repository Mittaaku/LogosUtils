//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 14/07/2023.
//

import Foundation

import XCTest

class DictionaryExtensionsTests: XCTestCase {
	
	// MARK: - flipped()
	
	func testFlipped_emptyDictionary_returnsEmptyDictionary() {
		let dictionary: [Int: String] = [:]
		
		let flippedDictionary = dictionary.flipped()
		
		XCTAssertTrue(flippedDictionary.isEmpty)
	}
	
	func testFlipped_dictionaryWithUniqueValues_returnsFlippedDictionary() {
		let dictionary = [1: "A", 2: "B", 3: "C"]
		let expectedFlippedDictionary = ["A": 1, "B": 2, "C": 3]
		
		let flippedDictionary = dictionary.flipped()
		
		XCTAssertEqual(flippedDictionary, expectedFlippedDictionary)
	}
	
	func testFlipped_dictionaryWithDuplicateValues_returnsFlippedDictionaryWithUniqueKeys() {
		let dictionary = [1: "A", 2: "B", 3: "A"]
		let expectedFlippedDictionary = ["A": 3, "B": 2]
		
		let flippedDictionary = dictionary.flipped()
		
		XCTAssertEqual(flippedDictionary, expectedFlippedDictionary)
	}
	
	// MARK: - sequentiallyFlipped()
	
	func testSequentiallyFlipped_emptyDictionary_returnsEmptyDictionary() {
		let dictionary: [Int: [String]] = [:]
		
		let sequentiallyFlippedDictionary = dictionary.sequentiallyFlipped()
		
		XCTAssertTrue(sequentiallyFlippedDictionary.isEmpty)
	}
	
	func testSequentiallyFlipped_dictionaryWithUniqueElements_returnsSequentiallyFlippedDictionary() {
		let dictionary = [1: ["A", "B", "C"], 2: ["D", "E"], 3: ["F"]]
		let expectedSequentiallyFlippedDictionary = ["A": 1, "B": 1, "C": 1, "D": 2, "E": 2, "F": 3]
		
		let sequentiallyFlippedDictionary = dictionary.sequentiallyFlipped()
		
		XCTAssertEqual(sequentiallyFlippedDictionary, expectedSequentiallyFlippedDictionary)
	}
	
	// MARK: - duplicatingCaseKeys()
	
	func testDuplicatingCaseKeys_emptyDictionary_returnsEmptyDictionary() {
		let dictionary: [String: Any] = [:]
		
		let duplicatedKeysDictionary = dictionary.duplicatingCaseKeys()
		
		XCTAssertTrue(duplicatedKeysDictionary.isEmpty)
	}
	
	func testDuplicatingCaseKeys_dictionaryWithUniqueKeys_returnsDictionaryWithDuplicatedCaseKeys() {
		let dictionary = ["First Name": "John"]
		let expectedDuplicatedKeysDictionary = ["First Name": "John", "first name": "John", "firstName": "John"]
		
		let duplicatedKeysDictionary = dictionary.duplicatingCaseKeys()
		
		XCTAssertEqual(duplicatedKeysDictionary, expectedDuplicatedKeysDictionary)
	}
}
