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
    
    func testMatchesToArray() {
        XCTAssertEqual(NSRegularExpression(#"^(\d+)_\w+.(\d+).(\d+)"#).matchesToArray(string: ref), [["41", "001", "002"]])
    }
    
    func testReplacing() {
        XCTAssertEqual(NSRegularExpression(#"e"#).replace(string: alphanumerics, withTemplate: "a"), "4avar")
        XCTAssertEqual(NSRegularExpression(#"[a-z]"#).replace(string: alphanumerics, withTemplate: "R"), "4RRRR")
    }
	
	func testBytes() {
		XCTAssertEqual(0xFF12.bytes, [0x12, 0xFF, 0, 0, 0, 0, 0, 0])
	}
}
