//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 16/11/2022.
//

import XCTest
@testable import LogosUtils

final class ReferenceTests: XCTestCase {
	
	let reference1 = Reference(book: 3, chapter: 1, verse: 3)
	let reference2 = Reference(book: 3, chapter: 1, verse: 4)
	let reference3 = Reference(book: 3, chapter: 2, verse: 1)
	let reference4 = Reference(book: 1, chapter: 2, verse: 1)
	let reference5 = Reference(book: 1, chapter: 2, verse: 3)
	
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
	}
}
