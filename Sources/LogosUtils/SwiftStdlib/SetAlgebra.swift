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
	
	@discardableResult mutating func insertIfNotNil(_ value: Element?) -> Bool {
		guard let value else {
			return false
		}
		self.insert(value)
		return true
	}
}

public extension SetAlgebra where Element == String {
	
	func makeUniqueElement(fromCamelCaseString string: String) -> String {
		assert(!string.isEmpty, "Input string cannot be empty")
		var element = ""
		
		let first = string.first!
		assert(!first.isUppercase, "Input string is not camel case")
		element.append(first)
		
		for character in string {
			if character.isUppercase {
				element.append(character.lowercased())
			} else if character.isNumber {
				element.append(character)
			}
		}
		
		let elementPrefix = element
		var counter = 1
		while contains(element) {
			element = "\(elementPrefix)\(counter)"
			counter += 1
		}
		
		return element
	}
}
