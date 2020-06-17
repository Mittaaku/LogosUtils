import XCTest
@testable import LogosUtils

final class SequenceTests: XCTestCase {
    static let intArray = [1, 3, 4, 2, 6]
    static let incrementedIntArray = intArray.map { $0 + 10 }
    static let evenIntArray = intArray.filter(\.isEven)
    static let oddIntArray = intArray.filter(\.isOdd)

    func testDivided() {
        let divided = Self.intArray.divided { $0.isEven }
        XCTAssertEqual(divided.matching, Self.evenIntArray)
        XCTAssertEqual(divided.notMatching, Self.oddIntArray)
    }

    func testSorted() {
        XCTAssertEqual(Self.intArray.sorted(byKeyPaths: \.abs, ascending: true), [1, 2, 3, 4, 6])
        XCTAssertEqual(Self.intArray.sorted(byKeyPaths: \.isEvenInt, \.abs, ascending: true), [1, 3, 2, 4, 6])
    }
}

fileprivate extension Int {
    var isEvenInt: Int {
        return isEven ? 1 : 0
    }
}
