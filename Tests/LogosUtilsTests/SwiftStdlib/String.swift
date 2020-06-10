import XCTest
@testable import LogosUtils

final class StringTests: XCTestCase {

    let letters = "Hello"
    let alphanumerics = "4ever"

    func testConsists() {
        XCTAssertEqual(letters.contains(set: .letters), true)
        XCTAssertEqual(letters.contains(set: .whitespaces), false)
    }

    func testContains() {
        XCTAssertEqual(letters.consists(ofSet: .alphanumerics), true)
        XCTAssertEqual(letters.consists(ofSet: .whitespaces), false)
    }

    func testExtractFirst() {
        var mutable = letters
        let extract = mutable.extractFirst(2)
        XCTAssertEqual(mutable, "llo")
        XCTAssertEqual(extract, "He")
    }

    func testExtractLast() {
        var mutable = letters
        let extract = mutable.extractLast(2)
        XCTAssertEqual(mutable, "Hel")
        XCTAssertEqual(extract, "lo")
    }

    func testMatches() {
        XCTAssertEqual(letters.matches(pattern: #"\w"#), true)
        XCTAssertEqual(letters.matches(pattern: #"\d"#), false)
    }

    func testNonBlanked() {
        let nonBlank = "World"
        let blank = ""
        XCTAssertEqual(nonBlank.nonBlanked(or: "Home"), "World")
        XCTAssertEqual(blank.nonBlanked(or: "Home"), "Home")
    }

    func testFiltering() {
        XCTAssertEqual(try alphanumerics.filtering(pattern: #"([a-z])"#), "ever")
        XCTAssertEqual(alphanumerics.filtering(set: .letters), "ever")
    }

    func testReplacing() {
        XCTAssertEqual(try alphanumerics.replacing(pattern: "e", withTemplate: "a"), "4avar")
        XCTAssertEqual(try alphanumerics.replacing(pattern: #"[a-z]"#, withTemplate: "R"), "4RRRR")
    }

    func testSplitting() {
        XCTAssertEqual(try alphanumerics.splitting(byPattern: "4"), ["ever"])
        XCTAssertEqual(try alphanumerics.splitting(byPattern: "(4)"), ["4", "ever"])
        XCTAssertEqual(try alphanumerics.splitting(byPattern: "e"), ["4", "v", "r"])
    }

    func testStrippingDiacritics() {
        XCTAssertEqual("áa".strippingDiacritics(), "aa")
    }
}
