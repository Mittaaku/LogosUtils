import XCTest
@testable import LogosUtils

final class OptionalTests: XCTestCase {
    let setOptinal: Int? = 1
    let unsetOptional: Int? = nil

    struct MockError: Error {}

    func testUnwrapped() {
        XCTAssertNoThrow(try setOptinal.unwrapped(or: MockError()))
        XCTAssertThrowsError(try unsetOptional.unwrapped(or: MockError()))
    }
}
