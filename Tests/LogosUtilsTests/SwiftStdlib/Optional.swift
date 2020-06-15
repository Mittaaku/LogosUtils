import XCTest
@testable import LogosUtils

final class OptionalTests: XCTestCase {
    let setOptinal: Bool? = true
    let unsetOptional: Bool? = nil

    struct MockError: Error {}

    func testNilCoalescingAssignmentOperator() {
        var i: Int?
        let j: Int? = nil
        i ??= 1
        XCTAssertEqual(i, 1)
        XCTAssertEqual(j, nil)
    }

    func testUnwrapped() {
        XCTAssertEqual(setOptinal.unwrapped(or: false), true)
        XCTAssertEqual(unsetOptional.unwrapped(or: false), false)
        do {
            try setOptinal.unwrapped(or: MockError())
        } catch {
            XCTFail()
        }
        do {
            try unsetOptional.unwrapped(or: MockError())
            XCTFail()
        } catch {
        }
    }
}
