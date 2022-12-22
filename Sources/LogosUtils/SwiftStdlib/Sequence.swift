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

    func anySatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try contains { try predicate($0) }
    }

    func divided(by condition: (Element) throws -> Bool) rethrows -> DividedResults {
        var divided: DividedResults = ([], [])
        for element in self {
            try condition(element) ? divided.matching.append(element) : divided.notMatching.append(element)
        }
        return divided
    }
    
    /// Returns an array containing, in order, the elements of the sequence
    /// that **do not** satisfy the given predicate.
    ///
    /// - Parameter isExcluded: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be excluded from the returned array.
    /// - Returns: An array of the elements that `isExcluded` blocked.
    func filterOut(_ isExcluded: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !isExcluded($0) }
    }
    
    func first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        return first { $0[keyPath: keyPath] == value }
    }
    
    func firstNonNil<T>(keyPath: KeyPath<Element, T?>) -> T? {
        var iterator = makeIterator()
        while let element = iterator.next() {
            if let set = element[keyPath: keyPath] {
                return set
            }
        }
        return nil
    }

    func noneSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try predicate($0) }
    }

    func sorted<T: Comparable>(byKeyPaths keyPaths: KeyPath<Element, T>..., ascending: Bool) -> [Element] {
        assert(keyPaths.count != 0, "Expected to receive at least one KeyPath.")
        let operation: (T, T) -> Bool = ascending ? { $0 < $1 } : { $0 > $1 }
        if keyPaths.count == 1 {
            let keyPath = keyPaths[0]
            return sorted {
                return operation($0[keyPath: keyPath], $1[keyPath: keyPath])
            }
        } else {
            var initialKeyPaths = keyPaths
            let finalKeyPath = initialKeyPaths.removeLast()
            return sorted {
                for keyPath in initialKeyPaths {
                    let lhs = $0[keyPath: keyPath], rhs = $1[keyPath: keyPath]
                    if lhs != rhs {
                        return operation(lhs, rhs)
                    }
                }
                return operation($0[keyPath: finalKeyPath], $1[keyPath: finalKeyPath])
            }
        }
    }

    func withoutDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
        var set = Set<T>()
        return try filter { set.insert(try transform($0)).inserted }
    }
}
