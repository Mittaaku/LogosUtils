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
    
    func testFilter() {
        XCTAssertEqual(try! alphanumerics.filter(byRegex: NSRegularExpression(pattern: #"[0-9]"#)), "4")
    }
    
    func testFiltrate() {
        let filtrated = try! alphanumerics.filtrate(byRegex: NSRegularExpression(pattern: #"[0-9]"#))
        XCTAssertEqual(filtrated.matching, "4")
        XCTAssertEqual(filtrated.notMatching, "ever")
    }

    func testMatches() {
        XCTAssertTrue(letters.matches(pattern: #"\w"#))
        XCTAssertFalse(letters.matches(pattern: #"\d"#))
    }

    func testNonBlanked() {
        XCTAssertEqual(letters.nonBlanked(or: "Was Blank"), "Hello")
        XCTAssertEqual(blank.nonBlanked(or: "Was Blank"), "Was Blank")
    }

    func testReplacing() {
        XCTAssertEqual(try alphanumerics.replacing(pattern: "e", withTemplate: "a"), "4avar")
        XCTAssertEqual(try alphanumerics.replacing(pattern: #"[a-z]"#, withTemplate: "R"), "4RRRR")
    }

    func testSplitting() {
        XCTAssertEqual(try alphanumerics.splitting(byRegex: NSRegularExpression(pattern: "4")), ["ever"])
        XCTAssertEqual(try alphanumerics.splitting(byRegex: NSRegularExpression(pattern: "(4)")), ["4", "ever"])
        XCTAssertEqual(try alphanumerics.splitting(byRegex: NSRegularExpression(pattern: "e")), ["4", "v", "r"])
    }

    func testStrippingDiacritics() {
        XCTAssertEqual("áa".strippingDiacritics(), "aa")
    }
}
