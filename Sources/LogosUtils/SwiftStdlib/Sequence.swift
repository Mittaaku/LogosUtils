//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension Sequence {

    typealias DividedResults = (matching: [Element], notMatching: [Element])

    func divided(by condition: (Element) throws -> Bool) rethrows -> DividedResults {
        var divided: DividedResults = ([], [])
        for element in self {
            try condition(element) ? divided.matching.append(element) : divided.notMatching.append(element)
        }
        return divided
    }
	
	func filteringDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
		var set = Set<T>()
		return try filter { set.insert(try transform($0)).inserted }
	}

	func sorted<T: Comparable>(byKeyPaths keyPaths: KeyPath<Element, T>..., with comparison: (T, T) -> Bool) -> [Element] {
		assert(keyPaths.count != 0, "Expected to receive at least one KeyPath.")
		if keyPaths.count == 1 {
			let keyPath = keyPaths[0]
			return sorted {
				return comparison($0[keyPath: keyPath], $1[keyPath: keyPath])
			}
		} else {
			var initialKeyPaths = keyPaths
			let finalKeyPath = initialKeyPaths.removeLast()
			return sorted {
				for keyPath in initialKeyPaths {
					let lhs = $0[keyPath: keyPath], rhs = $1[keyPath: keyPath]
					if lhs != rhs {
						return comparison(lhs, rhs)
					}
				}
				return comparison($0[keyPath: finalKeyPath], $1[keyPath: finalKeyPath])
			}
		}
	}
}

extension Sequence where Element: Hashable {
	
	func filteredByUniqueHashes() -> [Element] {
		var set = Set<Element>()
		return filter { set.insert($0).inserted }
	}
}
