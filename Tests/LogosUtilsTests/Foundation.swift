import XCTest
@testable import LogosUtils

final class NSRegularExpressionTests: XCTestCase {
    
    let letters = "Hello"
    let alphanumerics = "4ever"
    let blank = ""
    let ref = "41_Mat.001.002"
    
    func testDivided() {
        let divided = NSRegularExpression(#"[0-9]"#).divide(string: alphanumerics)
        XCTAssertEqual(divided.matching, "4")
        XCTAssertEqual(divided.notMatching, "ever")
    }
    
    func testFilter() {
        XCTAssertEqual(NSRegularExpression(#"[0-9]"#).filter(string: alphanumerics), "4")
    }

    func testMatches() {
        XCTAssertTrue(letters ~= NSRegularExpression(#"\w"#))
        XCTAssertFalse(letters ~= NSRegularExpression(#"\d"#))
        let numericRegex = NSRegularExpression(#"[0-9]"#)
        XCTAssertTrue(alphanumerics ~= numericRegex)
        XCTAssertFalse(letters ~= numericRegex)
    }
    
    func testMatchesToArray() {
        XCTAssertEqual(NSRegularExpression(#"^(\d+)_\w+.(\d+).(\d+)"#).matchesToArray(string: ref), [["41", "001", "002"]])
    }
    
    func testReplacing() {
        XCTAssertEqual(NSRegularExpression(#"e"#).replace(string: alphanumerics, withTemplate: "a"), "4avar")
        XCTAssertEqual(NSRegularExpression(#"[a-z]"#).replace(string: alphanumerics, withTemplate: "R"), "4RRRR")
    }
    
    func testFirstMatch() {
        let test = NSRegularExpression(#"e"#).firstMatch(in: alphanumerics)
        XCTAssertNotNil(test)
    }

    func testSplit() {
        XCTAssertEqual(NSRegularExpression(#"4"#).split(string: alphanumerics), ["ever"])
        XCTAssertEqual(NSRegularExpression(#"(4)"#).split(string: alphanumerics), ["4", "ever"])
        XCTAssertEqual(NSRegularExpression(#"e"#).split(string: alphanumerics), ["4", "v", "r"])
    }
    
    func testStringStates() {
        XCTAssertTrue("".isBlank)
        XCTAssertTrue(" ".isBlank)
        XCTAssertFalse(".".isBlank)
        XCTAssertTrue("9".isDigits)
        XCTAssertFalse("".isDigits)
        XCTAssertFalse("".isWhitespace)
        XCTAssertTrue(" ".isWhitespace)
        XCTAssertFalse(".".isWhitespace)
    }
	
	func testBytes() {
		XCTAssertEqual(0xFF12.bytes, [0x12, 0xFF, 0, 0, 0, 0, 0, 0])
	}
}
