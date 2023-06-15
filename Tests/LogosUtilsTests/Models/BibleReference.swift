//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
@testable import LogosUtils

class BibleReferenceTests: XCTestCase {
	
	// MARK: - BookReference Tests
	
	func testBookReferenceCreation() {
		let bookReference = BookReference(rawValue: 2)
		XCTAssertEqual(bookReference.rawValue, 2)
	}
	
	func testBookReferenceBookIndex() {
		let bookReference = BookReference(book: BookIndex(rawValue: 3))
		XCTAssertEqual(bookReference.bookIndex.rawValue, 3)
	}
	
	func testBookReferenceNext() {
		let bookReference = BookReference(book: BookIndex(rawValue: 5))
		let nextReference = bookReference.next
		XCTAssertEqual(nextReference.bookIndex.rawValue, 6)
	}
	
	func testBibleReferenceContainerEncodeDecode() throws {
		let referenceContainer = BookReference(book: 45)
		
		let encoder = JSONEncoder()
		let jsonData = try encoder.encode(referenceContainer)
		
		let decoder = JSONDecoder()
		let decodedContainer = try decoder.decode(BookReference.self, from: jsonData)
		
		XCTAssertEqual(decodedContainer.bookIndex, 45)
	}
	
	func testBibleReferenceContainerRawIndices() {
		let referenceContainer = BookReference(book: 45)
		let rawIndices = referenceContainer.rawIndices

		XCTAssertEqual(rawIndices, [45])
	}
	
	func testBibleReferenceContainerIndices() {
		let referenceContainer = BookReference(book: 254)
		let indices = referenceContainer.indices
		
		XCTAssertEqual(indices, [254])
	}
	
	func testBibleReferenceContainerEquality() {
		let reference1 = BookReference(book: 100)
		let reference2 = BookReference(book: 100)
		let reference3 = BookReference(book: 200)
		
		XCTAssertEqual(reference1, reference2)
		XCTAssertNotEqual(reference1, reference3)
	}
	
	func testBibleReferenceContainerComparison() {
		let reference1 = BookReference(book: 100)
		let reference2 = BookReference(book: 200)
		
		XCTAssertTrue(reference1 < reference2)
		XCTAssertFalse(reference2 < reference1)
	}
	
	func testBibleReferenceContainerOffset() {
		let reference1 = BookReference(book: 100)
		let reference2 = BookReference(book: 200)
		
		XCTAssertEqual(reference1.offset(from: reference2), .differentBook)
	}
	
	// MARK: - ChapterReference Tests
	
	func testChapterReferenceCreation() {
		let chapterReference = ChapterReference(rawValue: 2)
		XCTAssertEqual(chapterReference.rawValue, 2)
	}
	
	func testChapterReferenceChapterIndex() {
		let chapterReference = ChapterReference(book: BookIndex(rawValue: 3), chapter: ChapterIndex(rawValue: 5))
		XCTAssertEqual(chapterReference.chapterIndex.rawValue, 5)
	}
	
	func testChapterReferenceNext() {
		let chapterReference = ChapterReference(bookReference: BookReference(book: BookIndex(rawValue: 3)), chapter: ChapterIndex(rawValue: 5))
		let nextReference = chapterReference.next
		XCTAssertEqual(nextReference.chapterIndex.rawValue, 6)
	}
	
	// MARK: - VerseReference Tests
	
	func testVerseReferenceCreation() {
		let verseReference = VerseReference(rawValue: 2)
		XCTAssertEqual(verseReference.rawValue, 2)
	}
	
	func testVerseReferenceVerseIndex() {
		let verseReference = VerseReference(book: BookIndex(rawValue: 3), chapter: ChapterIndex(rawValue: 5), verse: VerseIndex(rawValue: 7))
		XCTAssertEqual(verseReference.verseIndex.rawValue, 7)
	}
	
	func testVerseReferenceNext() {
		let verseReference = VerseReference(chapterReference: ChapterReference(book: BookIndex(rawValue: 3), chapter: ChapterIndex(rawValue: 5)), verse: VerseIndex(rawValue: 7))
		let nextReference = verseReference.next
		XCTAssertEqual(nextReference.verseIndex.rawValue, 8)
	}
	
	// MARK: - TokenReference Tests
	
	func testTokenReferenceCreation() {
		let tokenReference = TokenReference(rawValue: 2)
		XCTAssertEqual(tokenReference.rawValue, 2)
	}
	
	func testTokenReferenceTokenIndex() {
		let tokenReference = TokenReference(book: BookIndex(rawValue: 3), chapter: ChapterIndex(rawValue: 5), verse: VerseIndex(rawValue: 7), token: TokenIndex(rawValue: 10))
		XCTAssertEqual(tokenReference.tokenIndex.rawValue, 10)
	}
	
	func testTokenReferenceNext() {
		let tokenReference = TokenReference(verseReference: VerseReference(book: BookIndex(rawValue: 3), chapter: ChapterIndex(rawValue: 5), verse: VerseIndex(rawValue: 7)), token: TokenIndex(rawValue: 10))
		let nextReference = tokenReference.next
		XCTAssertEqual(nextReference.tokenIndex.rawValue, 11)
	}
	
	func testRange() {
		let ref0 = BookReference(book: 1)
		let ref1 = BookReference(book: 3)
		let range = ref0 ..< ref1
	}
}
