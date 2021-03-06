//
//  SetAlgebra.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/14/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
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
}
