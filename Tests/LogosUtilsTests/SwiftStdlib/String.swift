import XCTest
@testable import LogosUtils

final class StringTests: XCTestCase {

    let letters = "Hello"
    let alphanumerics = "4ever"
    let blank = ""

    func testContains() {
        XCTAssertTrue(letters.contains(set: .letters))
        XCTAssertFalse(letters.contains(set: .whitespaces))
    }

    func testConsists() {
        XCTAssertTrue(letters.consists(ofSet: .letters))
        XCTAssertFalse(letters.consists(ofSet: .whitespaces))
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

    func testNonBlanked() {
        XCTAssertEqual(letters.nonBlanked(or: "Was Blank"), "Hello")
        XCTAssertEqual(blank.nonBlanked(or: "Was Blank"), "Was Blank")
    }

    func testStrippingDiacritics() {
        XCTAssertEqual("áa".strippingDiacritics(), "aa")
    }
}
