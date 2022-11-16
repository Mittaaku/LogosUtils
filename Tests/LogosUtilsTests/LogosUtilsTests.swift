import XCTest
@testable import LogosUtils

final class LogosUtilsTests: XCTestCase {

    func otherTests() {

        // Sorting

        // Encode/Decode

        if #available(OSX 10.15, iOS 13, *) {
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
        XCTAssertEqual(strings.map(\.count), [3, 5, 4])

    }

    func testReuse() {
        measure {
            let wow = "This is a .magics test"
            let regex = try! NSRegularExpression(pattern: ".magic[fs]")
            let range = NSRange(location: 0, length: wow.utf16.count)
            for _ in 0 ..< 1000 {
				_ = regex.firstMatch(in: wow, options: [], range: range)
            }
        }
    }

    func testNew() {
        measure {
            let wow = "This is a .magics test"
            for _ in 0 ..< 1000 {
				_ = wow.range(of: ".magic[fs]", options: .regularExpression, range: nil, locale: nil)
            }
        }
    }
}
