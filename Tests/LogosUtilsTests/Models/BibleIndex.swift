//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
@testable import LogosUtils

class BibleIndexTests: XCTestCase {
	
	// MARK: - BookIndex Tests
	
	func testBookIndexCreation() {
		let bookIndex = BookIndex(1)
		XCTAssertEqual(bookIndex.rawValue, 1)
		XCTAssertEqual(bookIndex.description, "1")
		
		let bookIndexFromName1 = BookIndex(englishName: "Genesis")
		XCTAssertEqual(bookIndexFromName1?.rawValue, 1)
		
		let bookIndexFromName2 = BookIndex(englishName: "2 Cor")
		XCTAssertEqual(bookIndexFromName2?.rawValue, 47)
		
		let bookIndexFromName3 = BookIndex(englishName: "firstKings")
		XCTAssertEqual(bookIndexFromName3?.rawValue, 11)
		
		let invalidBookIndexFromName = BookIndex(englishName: "Invalid")
		XCTAssertNil(invalidBookIndexFromName)
	}
	
	func testBookIndexIntegerLiteralCreation() {
		let bookIndex: BookIndex = 10
		XCTAssertEqual(bookIndex.rawValue, 10)
	}
	
	func testBookIndexArithmetic() {
		let bookIndex1 = BookIndex(1)
		let bookIndex2 = BookIndex(2)
		
		let sum = bookIndex1 + bookIndex2
		XCTAssertEqual(sum.rawValue, 3)
		
		let diff = bookIndex2 - bookIndex1
		XCTAssertEqual(diff.rawValue, 1)
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
	
	func testChapterIndexArithmetic() {
		let chapterIndex1 = ChapterIndex(1)
		let chapterIndex2 = ChapterIndex(2)
		
		let sum = chapterIndex1 + chapterIndex2
		XCTAssertEqual(sum.rawValue, 3)
		
		let diff = chapterIndex2 - chapterIndex1
		XCTAssertEqual(diff.rawValue, 1)
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
	
	func testVerseIndexArithmetic() {
		let verseIndex1 = VerseIndex(1)
		let verseIndex2 = VerseIndex(2)
		
		let sum = verseIndex1 + verseIndex2
		XCTAssertEqual(sum.rawValue, 3)
		
		let diff = verseIndex2 - verseIndex1
		XCTAssertEqual(diff.rawValue, 1)
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
	
	func testTokenIndexArithmetic() {
		let tokenIndex1 = TokenIndex(1)
		let tokenIndex2 = TokenIndex(2)
		
		let sum = tokenIndex1 + tokenIndex2
		XCTAssertEqual(sum.rawValue, 3)
		
		let diff = tokenIndex2 - tokenIndex1
		XCTAssertEqual(diff.rawValue, 1)
	}
}
