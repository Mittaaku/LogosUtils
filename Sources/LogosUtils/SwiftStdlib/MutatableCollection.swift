//
//  MutableCollection.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/15/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension MutableCollection {

    mutating func mapInPlace(_ transform: (Element) throws -> Element) rethrows {
        for i in indices {
            self[i] = try transform(self[i])
        }
    }

    mutating func updateEach(_ transform: (inout Element) throws -> Void) rethrows {
        for i in indices {
            try transform(&self[i])
        }
    }
}

public extension MutableCollection where Self: RangeReplaceableCollection {

    mutating func compactMapInPlace(_ transform: (Element) throws -> Element?) rethrows {
        var availableIndexIterator = indices.makeIterator()
        var nextAvailableIndex = availableIndexIterator.next()!
        for currentSlot in indices {
            guard let element = try transform(self[currentSlot]) else {
                continue
            }
            self[nextAvailableIndex] = element
            nextAvailableIndex = availableIndexIterator.next()!
        }
        removeSubrange(nextAvailableIndex ..< endIndex)
    }

    mutating func filterInPlace(by predicate: (Element) throws -> Bool) rethrows {
        var availableIndexIterator = indices.makeIterator()
        var nextAvailableIndex = availableIndexIterator.next()!
        for currentSlot in indices {
            let element = self[currentSlot]
            guard try predicate(element) else {
                continue
            }
            self[nextAvailableIndex] = element
            nextAvailableIndex = availableIndexIterator.next()!
        }
        removeSubrange(nextAvailableIndex ..< endIndex)
        return
    }
    
    mutating func filterOutInPlace(by predicate: (Element) throws -> Bool) rethrows {
        var availableIndexIterator = indices.makeIterator()
        var nextAvailableIndex = availableIndexIterator.next()!
        for currentSlot in indices {
            let element = self[currentSlot]
            guard try !predicate(element) else {
                continue
            }
            self[nextAvailableIndex] = element
            nextAvailableIndex = availableIndexIterator.next()!
        }
        removeSubrange(nextAvailableIndex ..< endIndex)
        return
    }

    mutating func partitionOff(by predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var availableIndexIterator = indices.makeIterator()
        var nextAvailableIndex = availableIndexIterator.next()!
        var partitionedOff = [Element]()
        for currentSlot in indices {
            let element = self[currentSlot]
            guard try !predicate(element) else {
                partitionedOff.append(element)
                continue
            }
            self[nextAvailableIndex] = element
            nextAvailableIndex = availableIndexIterator.next()!
        }
        removeSubrange(nextAvailableIndex ..< endIndex)
        return partitionedOff
    }
}
