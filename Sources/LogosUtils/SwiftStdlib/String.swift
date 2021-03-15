//
//  String.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/13/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension String {

    var characters: [Character] {
        return Array(self)
    }

    var isBlank: Bool {
        return consists(ofSet: .whitespaces)
    }

    var nonBlank: Self? {
        return isBlank ? nil : self
    }
}

// MARK: - Methods
public extension String {

    /// LogosUtils: Check whether the String contains one or more of the characters in the input CharacterSet
    func contains(set: CharacterSet) -> Bool {
        return self.rangeOfCharacter(from: set, options: .literal, range: nil) != nil
    }

    /// LogosUtils: Check whether the String consists of (only contains) the characters in the input CharacterSet.
    func consists(ofSet set: CharacterSet) -> Bool {
        return set.isSuperset(of: CharacterSet(charactersIn: self))
    }

    mutating func extractFirst(_ k: Int) -> String {
        let result = String(prefix(k))
        removeFirst(k)
        return result
    }

    mutating func extractLast(_ k: Int) -> String {
        let result = String(suffix(k))
        removeLast(k)
        return result
    }

    func nonBlanked(or error: @autoclosure () -> Swift.Error) throws -> Self {
        guard let value = nonBlank else {
            throw error()
        }
        return value
    }

    func nonBlanked(or defaultValue: @autoclosure () -> Self) -> Self {
        return nonBlank ?? defaultValue()
    }

    func strippingDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}

func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
    return rhs.matches(string: lhs)
}
