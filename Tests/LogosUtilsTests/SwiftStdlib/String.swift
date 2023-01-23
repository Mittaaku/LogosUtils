import XCTest
@testable import LogosUtils

final class StringTests: XCTestCase {

    let letters = "Hello"
    let alphanumerics = "4ever"
    let blank = ""

    func testContains() {
		XCTAssertTrue(letters.contains(characterFromSet: .letters))
		XCTAssertFalse(letters.contains(characterFromSet: .whitespaces))
    }

    func testConsists() {
		XCTAssertTrue(letters.consists(ofCharactersFromSet: .letters))
		XCTAssertFalse(letters.consists(ofCharactersFromSet: .whitespaces))
    }

    func testExtractFirst() {
        var mutable = letters
        let extractCount = 3
        let remainCount = mutable.count - extractCount
        let extract = mutable.extractFirst(extractCount)
        XCTAssertEqual(mutable, String(letters.suffix(remainCount)))
        XCTAssertEqual(extract, String(letters.prefix(extractCount)))
    }

    func testExtractLast() {
        var mutable = letters
        let extractCount = 3
        let remainCount = mutable.count - extractCount
        let extract = mutable.extractLast(extractCount)
        XCTAssertEqual(mutable, String(letters.prefix(remainCount)))
        XCTAssertEqual(extract, String(letters.suffix(extractCount)))
    }

    func testStrippingDiacritics() {
        XCTAssertEqual("áa".strippingDiacritics(), "aa")
    }
	
	func testIsGreek() {
		XCTAssertEqual("φύἐάὶηη".isGreek, true)
		XCTAssertEqual("φηη".isGreek, true)
		XCTAssertEqual("φγfηη".isGreek, false)
		XCTAssertEqual("".isGreek, false)
		XCTAssertEqual("f".isGreek, false)
		
		XCTAssertEqual("φγηη φηη".isSpacedGreek, true)
		XCTAssertEqual("φηη fwfw".isSpacedGreek, false)
	}
	
	func testIsHebrew() {
		XCTAssertEqual("וְרוּו".isHebrew, true)
		XCTAssertEqual("כככיקיחק".isHebrew, true)
		XCTAssertEqual("כככיddקיחק".isHebrew, false)
		XCTAssertEqual(" ".isHebrew, false)
		XCTAssertEqual("".isHebrew, false)
		XCTAssertEqual("f".isHebrew, false)
		
		XCTAssertEqual("כככי קיחק".isSpacedHebrew, true)
		XCTAssertEqual("כככי fwfw".isSpacedHebrew, false)
	}
	
	func testUppercaseRange() {
		let string = "testing"
		let range = string.index(string.endIndex, offsetBy: -2) ..< string.endIndex
		XCTAssertEqual(string.uppercased(range: range), "testiNG")
	}
}
