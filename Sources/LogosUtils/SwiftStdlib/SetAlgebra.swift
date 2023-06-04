//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

public extension SetAlgebra {
	
	/// Initializes a set as the intersection of multiple sets.
	///
	/// - Parameter sets: An array of sets to intersect.
	init(intersectionOf sets: [Self]) {
		var iterator = sets.makeIterator()
		var result = iterator.next()!
		while let next = iterator.next() {
			result.formIntersection(next)
		}
		self = result
	}
	
	/// Initializes a set as the symmetric difference of multiple sets.
	///
	/// - Parameter sets: An array of sets to compute the symmetric difference.
	init(symmetricDifferenceOf sets: [Self]) {
		var iterator = sets.makeIterator()
		var result = iterator.next()!
		while let next = iterator.next() {
			result.formSymmetricDifference(next)
		}
		self = result
	}
	
	/// Initializes a set as the union of multiple sets.
	///
	/// - Parameter sets: An array of sets to union.
	init(unionOf sets: [Self]) {
		var iterator = sets.makeIterator()
		var result = iterator.next()!
		while let next = iterator.next() {
			result.formUnion(next)
		}
		self = result
	}
	
	/// Inserts a value into the set if it is not nil.
	///
	/// - Parameter value: The value to insert.
	/// - Returns: `true` if the value was inserted, `false` otherwise.
	@discardableResult
	mutating func insertIfNotNil(_ value: Element?) -> Bool {
		guard let value else {
			return false
		}
		self.insert(value)
		return true
	}
}

public extension SetAlgebra where Element == String {
	
	/// Creates a unique element from a camel case string.
	///
	/// - Parameter string: The string to extract initials from.
	/// - Returns: A unique element derived from the input string.
	func makeUniqueElement(fromString string: String) -> String? {
		
		guard let initials = string.extractInitials().nonBlank else {
			return nil
		}
		
		var element = initials
		
		let elementPrefix = element
		var counter = 1
		while contains(element) {
			element = "\(elementPrefix)\(counter)"
			counter += 1
		}
		
		return element
	}
}
#endif
