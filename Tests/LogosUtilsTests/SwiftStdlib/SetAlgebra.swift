import XCTest
@testable import LogosUtils

final class SetAlgebraTests: XCTestCase {
    let set0: Set = [3, 6, 1]
    let set1: Set = [3, 0]

    func testInitUnionOf() {
        XCTAssertEqual(Set(unionOf: [set0, set1]), Set([3, 6, 1, 0]))
    }

    func testInitSymmetricDifferenceOf() {
        XCTAssertEqual(Set(symmetricDifferenceOf: [set0, set1]), Set([6, 1, 0]))
    }

    func testInitIntersectionOf() {
        XCTAssertEqual(Set(intersectionOf: [set0, set1]), Set([3]))
    }
}
