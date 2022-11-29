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
	var reference5 = Reference(book: 1, chapter: 2, verse: 3, word: 1, morpheme: 2)
	var reference6 = Reference(book: 1)
	var reference7 = Reference(book: 66)
	
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
		
		reference5.bookNumber += 1
		XCTAssertEqual(reference5.bookNumber, 2)
		
		reference5.chapterNumber += 1
		XCTAssertEqual(reference5.chapterNumber, 3)
		
		reference5.verseNumber += 1
		XCTAssertEqual(reference5.verseNumber, 4)
		
		reference5.wordNumber += 1
		XCTAssertEqual(reference5.wordNumber, 2)
		
		reference5.morphemeNumber += 1
		XCTAssertEqual(reference5.morphemeNumber, 3)
		
		reference5.bookNumber += 1
		XCTAssertEqual(reference5.bookNumber, 3)
		
		XCTAssertEqual(reference6.bookName, .genesis)
		XCTAssertEqual(reference7.bookName, .revelation)
		XCTAssertEqual(reference1.description, "[3, 1, 3, 0, 0]")
		
		XCTAssertEqual(reference1.isBookReference, false)
		XCTAssertEqual(reference1.isChapterReference, false)
		XCTAssertEqual(reference1.isVerseReference, true)
		XCTAssertEqual(reference1.isWordReference, false)
		XCTAssertEqual(reference1.isMorphemeReference, false)
	}
}
