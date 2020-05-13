import XCTest
@testable import LogosUtils

final class LogosUtilsTests: XCTestCase {
    
    func testStrings() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LogosUtils().text, "Hello, World!")
        
        let latinString = "HelloWorld"
        let numericString = "1657"
        let japaneseString = "おはよう世界"
        let alphanumericString = "fgg22"
        let hiraganaLatinString = "おはようWorld"
        
        // Consists
        XCTAssertEqual(latinString.consists(ofCategory: .latin), true)
        XCTAssertEqual(japaneseString.consists(ofCategory: .hiragana, .katakana, .han), true)
        XCTAssertEqual(alphanumericString.consists(ofCategory: .latin), false)
        
        // Contains
        XCTAssertEqual(latinString.contains(category: .latin), true)
        XCTAssertEqual(numericString.contains(category: .latin), false)
        XCTAssertEqual(alphanumericString.contains(category: .latin), true)
        
        // Whitelisting
        XCTAssertEqual(try hiraganaLatinString.whitelisting(category: .hiragana), "おはよう")
        XCTAssertEqual(try hiraganaLatinString.whitelisting(category: .latin), "World")
        XCTAssertEqual(try numericString.whitelisting(category: .number), "1657")
        XCTAssertEqual(try latinString.whitelisting(category: .number), "")
        
        // Blacklisting
        XCTAssertEqual(try hiraganaLatinString.blacklisting(category: .hiragana), "World")
        XCTAssertEqual(try alphanumericString.blacklisting(category: .latin), "22")
        XCTAssertEqual(try numericString.blacklisting(category: .han), "1657")
        XCTAssertEqual(try numericString.blacklisting(category: .number), "")
    }

    static var allTests = [
        ("stringTest", testStrings),
    ]
}
