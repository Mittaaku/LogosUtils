import XCTest
@testable import LogosUtils

final class SequenceTests: XCTestCase {
    static let intArray = [1, 3, 4, 2, 6]
    static let incrementedIntArray = intArray.map { $0 + 10 }
	static let evenIntArray = intArray.filter { $0 % 2 == 0 }
	static let oddIntArray = intArray.filter { $0 % 2 == 1 }

    func testDivided() {
		let divided = Self.intArray.divided { $0 % 2 == 0 }
        XCTAssertEqual(divided.matching, Self.evenIntArray)
        XCTAssertEqual(divided.notMatching, Self.oddIntArray)
    }

    func testSorted() {
		XCTAssertEqual(Self.intArray.sorted(byKeyPaths: \.self, with: <), [1, 2, 3, 4, 6])
    }
}
