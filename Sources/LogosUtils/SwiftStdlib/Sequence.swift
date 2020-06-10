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

    func anySatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try contains { try predicate($0) }
    }

    func noneSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try predicate($0) }
    }

    func reject(_ isExcluded: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !isExcluded($0) }
    }

    func sorted<T: Comparable>(ascendingBy keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted {
            return $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }

    func sorted<T: Comparable>(descendingBy keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted {
            return $0[keyPath: keyPath] > $1[keyPath: keyPath]
        }
    }
}
