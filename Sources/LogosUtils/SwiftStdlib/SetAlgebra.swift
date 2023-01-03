//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Initializers
public extension SetAlgebra {
    init(intersectionOf sets: [Self]) {
        var iterator = sets.makeIterator()
        var result = iterator.next()!
        while let next = iterator.next() {
            result.formIntersection(next)
        }
        self = result
    }

    init(symmetricDifferenceOf sets: [Self]) {
        var iterator = sets.makeIterator()
        var result = iterator.next()!
        while let next = iterator.next() {
            result.formSymmetricDifference(next)
        }
        self = result
    }

    init(unionOf sets: [Self]) {
        var iterator = sets.makeIterator()
        var result = iterator.next()!
        while let next = iterator.next() {
            result.formUnion(next)
        }
        self = result
    }
	
	@discardableResult mutating func insertIf(nonNil value: Element?) -> Bool {
		guard let value else {
			return
		}
		self.insert(value)
	}
}
