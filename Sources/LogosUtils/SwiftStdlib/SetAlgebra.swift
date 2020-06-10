//
//  SetAlgebra.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/14/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

extension SetAlgebra {
}

extension Sequence where Element: SetAlgebra {
    func intersectionOfElements() -> Element {
        var iterator = self.makeIterator()
        var result = iterator.next()!
        while let next = iterator.next() {
            result.formIntersection(next)
        }
        return result
    }

    func symmetricDifferenceOfElements() -> Element {
        var iterator = self.makeIterator()
        var result = iterator.next()!
        while let next = iterator.next() {
            result.formSymmetricDifference(next)
        }
        return result
    }

    func unionOfElements() -> Element {
        var iterator = self.makeIterator()
        var result = iterator.next()!
        while let next = iterator.next() {
            result.formUnion(next)
        }
        return result
    }
}
