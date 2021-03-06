import XCTest
@testable import LogosUtils

final class MutatableCollectionTests: XCTestCase {
    static let intArray = [1, 3, 4, 2, 6]
    static let incrementedIntArray = intArray.map { $0 + 1 }
    static let evenIntArray = intArray.filter(\.isEven)
    static let oddIntArray = intArray.filter(\.isOdd)

    func testMapInPlace() {
        var mutatingArray = Self.intArray
        mutatingArray.mapInPlace { $0 + 1 }
        XCTAssertEqual(mutatingArray, Self.incrementedIntArray)
    }

    func testMutateMap() {
        var mutatingArray = Self.intArray
        mutatingArray.mutateMap { $0 += 1 }
        XCTAssertEqual(mutatingArray, Self.incrementedIntArray)
    }

    func testCompactMapInPlace() {
        var mutatingArray = Self.intArray
        mutatingArray.compactMapInPlace { $0.isEven ? $0 : nil }
        XCTAssertEqual(mutatingArray, Self.evenIntArray)
    }

    func testKeepAll() {
        var mutatingArray = Self.intArray
        mutatingArray.keepAll(where: \.isEven)
        XCTAssertEqual(mutatingArray, Self.evenIntArray)
    }

    func testPartitionOff() {
        var mutatingArray = Self.intArray
        let partitioned = mutatingArray.partitionOff(by: \.isEven)
        XCTAssertEqual(partitioned, Self.evenIntArray)
        XCTAssertEqual(mutatingArray, Self.oddIntArray)
    }
}
