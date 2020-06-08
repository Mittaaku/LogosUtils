import XCTest
@testable import LogosUtils

final class LogosUtilsTests: XCTestCase {
    
    func testStrings() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let latinString = "HelloWorld"
        let numericString = "1657"
        let japaneseString = "おはよう世界"
        let alphanumericString = "fgg22"
        let hiraganaLatinString = "おはようWorld"
        let dashedString = "Hello-World"
        
        // Consists
        XCTAssertEqual(latinString.consists(ofCategory: .latin), true)
        XCTAssertEqual(japaneseString.consists(ofCategory: .hiragana, .katakana, .han), true)
        XCTAssertEqual(alphanumericString.consists(ofCategory: .latin), false)
        XCTAssertEqual("     \t\n".consists(ofCategory: .whitespace), true)
        
        // Contains
        XCTAssertEqual(latinString.contains(category: .latin), true)
        XCTAssertEqual(numericString.contains(category: .latin), false)
        XCTAssertEqual(alphanumericString.contains(category: .latin), true)
        XCTAssertEqual("I love\nYou".contains(category: .whitespace), true)
        
        // Whitelisting
        XCTAssertEqual(hiraganaLatinString.whitelisting(category: .hiragana), "おはよう")
        XCTAssertEqual(hiraganaLatinString.whitelisting(category: .latin), "World")
        XCTAssertEqual(numericString.whitelisting(category: .number), "1657")
        XCTAssertEqual(latinString.whitelisting(category: .number), "")
        
        // Blacklisting
        XCTAssertEqual(hiraganaLatinString.blacklisting(category: .hiragana), "World")
        XCTAssertEqual(alphanumericString.blacklisting(category: .latin), "22")
        XCTAssertEqual(numericString.blacklisting(category: .han), "1657")
        XCTAssertEqual(numericString.blacklisting(category: .number), "")
        
        // Removing
        XCTAssertEqual(try dashedString.removing(pattern: "-"), "HelloWorld")
        
        // Replacing
        XCTAssertEqual(try dashedString.replacing(pattern: "-", withTemplate: "_"), "Hello_World")
        XCTAssertEqual(try dashedString.replacing(pattern: "(-)", withTemplate: "$1My$1"), "Hello-My-World")
        
        // Splitting
        XCTAssertEqual(try dashedString.splitting(byPattern: "-"), ["Hello", "World"])
        XCTAssertEqual(try dashedString.splitting(byPattern: "(-)"), ["Hello", "-", "World"])
        XCTAssertEqual(try dashedString.splitting(byPattern: "_"), ["Hello-World"])
        
        // Sorting
        let arrayNumbers = [9, 4, 1, 5]
        XCTAssertEqual(arrayNumbers.sorted(ascendingBy: \.abs), [1, 4, 5, 9])
        XCTAssertEqual(arrayNumbers.sorted(descendingBy: \.abs), [9, 5, 4, 1])
        
        // Blanks
        let nilString: String? = nil
        let optionalBlankString: String? = "     "
        let optionalPopulatedString: String? = "   d"
        XCTAssertEqual(nilString.isNilOrBlank, true)
        XCTAssertEqual(optionalBlankString.isNilOrBlank, true)
        XCTAssertEqual(optionalPopulatedString.isNilOrBlank, false)
        
        // Encode/Decode
        
        if #available(OSX 10.15, *) {
            do {
                let unencoded = ["Hello", "World"]
                let fileManager = FileManager.default
                try fileManager.encode(value: unencoded, intoJsonFile: "LogosUtilsTest", inFolder: .documents, inSubfolder: "LogosUtils")
                let decoded = try fileManager.decode(jsonFile: "LogosUtilsTest", intoType: Array<String>.self, inFolder: .documents, inSubfolder: "LogosUtils")!
                XCTAssertEqual(decoded, unencoded)
            } catch let error {
                print(error)
                XCTFail()
            }
        }
        
        // Map
        let strings = ["Wow", "Hello", "Meow"]
        XCTAssertEqual(strings.map(by: \.count), [3, 5, 4])
        
        // Cutting
        XCTAssertEqual(try "Hello-World......A-Magic".cutting(intoPattern: #"(\w+)-(\w+)[.]+\w+-(\w+)"#), ["Hello", "World", "Magic"])
    }

    static var allTests = [
        ("stringTest", testStrings),
    ]
}
