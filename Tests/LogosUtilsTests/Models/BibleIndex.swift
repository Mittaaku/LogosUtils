//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
@testable import LogosUtils

class BibleIndexTests: XCTestCase {
	
	// MARK: - BookIndex Tests
	
	func testBookIndexCreation() {
		let bookIndex = BookIndex(rawValue: 5)
		XCTAssertEqual(bookIndex.rawValue, 5)
	}
	
	func testBookIndexIntegerLiteralCreation() {
		let bookIndex: BookIndex = 10
		XCTAssertEqual(bookIndex.rawValue, 10)
	}
	
	func testBibleIndexFromDecoder() throws {
		let decoder = JSONDecoder()
		let jsonData = #"5"#.data(using: .utf8)!
		
		let bookIndex = try decoder.decode(BookIndex.self, from: jsonData)
		XCTAssertEqual(bookIndex.rawValue, 5)
	}
	
	func testBibleIndexToEncoder() throws {
		let encoder = JSONEncoder()
		let bookIndex = BookIndex(rawValue: 5)
		
		let jsonData = try encoder.encode(bookIndex)
		let jsonString = String(data: jsonData, encoding: .utf8)!
		
		XCTAssertEqual(jsonString, #"5"#)
	}
	
	func testBibleIndexID() {
		let bookIndex = BookIndex(rawValue: 5)
		XCTAssertEqual(bookIndex.id, 5)
	}
	
	func testBibleIndexDescription() {
		let bookIndex = BookIndex(rawValue: 5)
		XCTAssertEqual(bookIndex.description, "5")
	}
	
	func testBibleIndexAddition() {
		let index1 = BookIndex(rawValue: 5)
		let index2 = BookIndex(rawValue: 3)
		let sum = index1 + index2
		
		XCTAssertEqual(sum.rawValue, 8)
	}
	
	func testBibleIndexSubtraction() {
		let index1 = BookIndex(rawValue: 5)
		let index2 = BookIndex(rawValue: 3)
		let difference = index1 - index2
		
		XCTAssertEqual(difference.rawValue, 2)
	}
	
	// MARK: - ChapterIndex Tests
	
	func testChapterIndexCreation() {
		let chapterIndex = ChapterIndex(rawValue: 2)
		XCTAssertEqual(chapterIndex.rawValue, 2)
	}
	
	func testChapterIndexIntegerLiteralCreation() {
		let chapterIndex: ChapterIndex = 3
		XCTAssertEqual(chapterIndex.rawValue, 3)
	}
	
	// MARK: - VerseIndex Tests
	
	func testVerseIndexCreation() {
		let verseIndex = VerseIndex(rawValue: 10)
		XCTAssertEqual(verseIndex.rawValue, 10)
	}
	
	func testVerseIndexIntegerLiteralCreation() {
		let verseIndex: VerseIndex = 15
		XCTAssertEqual(verseIndex.rawValue, 15)
	}
	
	// MARK: - TokenIndex Tests
	
	func testTokenIndexCreation() {
		let tokenIndex = TokenIndex(rawValue: 100)
		XCTAssertEqual(tokenIndex.rawValue, 100)
	}
	
	func testTokenIndexIntegerLiteralCreation() {
		let tokenIndex: TokenIndex = 200
		XCTAssertEqual(tokenIndex.rawValue, 200)
	}
}
