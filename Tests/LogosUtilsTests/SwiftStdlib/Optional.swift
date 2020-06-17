import XCTest
@testable import LogosUtils

final class OptionalTests: XCTestCase {
    let setOptinal: Int? = 1
    let unsetOptional: Int? = nil

    struct MockError: Error {}

    func testNilCoalescingAssignmentOperator() {
        let i: Int? = nil
        var j: Int?
        j ??= 1
        XCTAssertNil(i)
        XCTAssertNotNil(j)
    }

    func testUnwrapped() {
        XCTAssertEqual(setOptinal.unwrapped(or: 1), 1)
        XCTAssertEqual(unsetOptional.unwrapped(or: 0), 0)
        XCTAssertNoThrow(try setOptinal.unwrapped(or: MockError()))
        XCTAssertThrowsError(try unsetOptional.unwrapped(or: MockError()))
    }
}
