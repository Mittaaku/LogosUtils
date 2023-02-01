import XCTest
@testable import LogosUtils

final class MutatableCollectionTests: XCTestCase {
    static let intArray = [1, 3, 4, 2, 6]
    static let incrementedIntArray = intArray.map { $0 + 1 }
	static let evenIntArray = intArray.filter { $0 % 2 == 0 }
	static let oddIntArray = intArray.filter { $0 % 2 == 1 }

    func testMapInPlace() {
        var mutatingArray = Self.intArray
        mutatingArray.mapInPlace { $0 + 1 }
        XCTAssertEqual(mutatingArray, Self.incrementedIntArray)
    }

    func testUpdateEach() {
        var mutatingArray = Self.intArray
        mutatingArray.updateEach { $0 += 1 }
        XCTAssertEqual(mutatingArray, Self.incrementedIntArray)
    }

    func testCompactMapInPlace() {
        var mutatingArray = Self.intArray
        mutatingArray.compactMapInPlace { ($0 % 2 == 0) ? $0 : nil }
        XCTAssertEqual(mutatingArray, Self.evenIntArray)
    }

    func testKeepAll() {
        var mutatingArray = Self.intArray
		mutatingArray.filterInPlace { $0 % 2 == 0 }
        XCTAssertEqual(mutatingArray, Self.evenIntArray)
    }

	func testPartitionOff() {
		var mutatingArray = Self.intArray
		let partitioned = mutatingArray.partitionOff { $0 % 2 == 0 }
        XCTAssertEqual(partitioned, Self.evenIntArray)
        XCTAssertEqual(mutatingArray, Self.oddIntArray)
    }
}
