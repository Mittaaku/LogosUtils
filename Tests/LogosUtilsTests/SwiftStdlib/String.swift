import Foundation
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
	
	@available(iOS 16.0, macOS 13.0, *)
	func testHtmlToMarkdown() {
		XCTAssertEqual("<i>wow</i> *<b>wow</b>".htmlToMarkdown, #"*wow* \***wow**"#)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func testIsBlank() {
		XCTAssertTrue("".isBlank)
		XCTAssertTrue(" ".isBlank)
		XCTAssertFalse(".".isBlank)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func testIsGreek() {
		XCTAssertEqual("φύἐάὶηη".isGreek, true)
		XCTAssertEqual("φηη".isGreek, true)
		XCTAssertEqual("φγfηη".isGreek, false)
		XCTAssertEqual("".isGreek, false)
		XCTAssertEqual("f".isGreek, false)
		
		XCTAssertEqual("φγηη φηη".isSpacedGreek, true)
		XCTAssertEqual("φηη fwfw".isSpacedGreek, false)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
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
	
	@available(iOS 16.0, macOS 13.0, *)
	func testSplitByAndRetrain() {
		typealias Result = (String?, String, String?)
		
		let string = "NA27+NA28+Tyn+SBL+WH+Treg+NIV  <2: TR+Byz"
		
		let regex1 = try! Regex<Substring>("<")
		let result1 = string.splitByAndRetrain(separator: regex1)
		let comparingResult1: [Result] = [(nil, "NA27+NA28+Tyn+SBL+WH+Treg+NIV  ", "<"), ("<", "2: TR+Byz", nil)]
		
		XCTAssertEqual(result1[0].leadingSeparator, comparingResult1[0].0)
		XCTAssertEqual(result1[0].content, comparingResult1[0].1)
		XCTAssertEqual(result1[0].trailingSeparator, comparingResult1[0].2)
		
		XCTAssertEqual(result1[1].leadingSeparator, comparingResult1[1].0)
		XCTAssertEqual(result1[1].content, comparingResult1[1].1)
		XCTAssertEqual(result1[1].trailingSeparator, comparingResult1[1].2)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func testFilter() {
		XCTAssertEqual("4ever".filter(using: try! Regex(#"\d+"#)), "4")
	}
}
