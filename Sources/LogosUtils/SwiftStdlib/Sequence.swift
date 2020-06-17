//
//  Sequence.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/16/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
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
    
    func noneSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try predicate($0) }
    }

    func reject(_ isExcluded: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !isExcluded($0) }
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
