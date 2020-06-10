//
//  Collection.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/14/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension Collection {

    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}

// MARK: - Methods
public extension Collection {

    func nonEmptied(or defaultValue: @autoclosure () -> Self) -> Self {
        return nonEmpty ?? defaultValue()
    }

    func nonEmptied(or error: @autoclosure () -> Swift.Error) throws -> Self {
        guard let value = nonEmpty else {
            throw error()
        }
        return value
    }

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
