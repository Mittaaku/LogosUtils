//
//  String.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/13/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

import Foundation

public extension String {
    enum RegexUnicodeCategory: String {
        case han = "Han" // Chinese Hanzi, Japanese Kanji, and Korean Hanja.
        case hiragana = "Hiragana"
        case katakana = "Katakana"
        case latin = "Latin"
        case letter = "L"
        case letterLowercase = "Li"
        case letterUppercase = "Lu"
        case number = "N"
        case numberDecimalDigit = "Nd"
    }
}

// MARK: - Methods
public extension String {
    
    func blacklisting(set: CharacterSet) -> String {
        let filtered = self.unicodeScalars.filter { !set.contains($0) }
        return String(filtered)
    }
    
    /// LogosUtils: Check whether the String contains one or more of the characters in the input unicode category(s).
    ///
    ///        "123abc".contains(category: .latin) -> true
    ///        "123".contains(category: .latin) -> false
    ///
    /// - Parameters:
    ///   - category: the unicode category(s) to check against (Variadic).
    /// - Returns: true if the String contains contains one or more of the characters in the input category(s).
    func contains(category: RegexUnicodeCategory ...) -> Bool {
        let pattern = category.reduce(into: "") { $0 += "\\p{\($1.rawValue)}" }
        return self.range(of: "[\(pattern)]", options: .regularExpression) != nil
    }
    
    /// LogosUtils: Check whether the String contains one or more of the characters in the input CharacterSet.
    ///
    ///        "123abc".contains(set: .letters) -> true
    ///        "123".contains(set: .letters) -> false
    ///
    /// - Parameters:
    ///   - set: the set to check against.
    /// - Returns: true if the String contains contains one or more of the characters in the input set.
    func contains(set: CharacterSet) -> Bool {
        return !self.whitelisting(set: set).isEmpty
    }
    
    /// LogosUtils: Check whether the String consists of (only contains) the characters in the input unicode category(s).
    ///
    ///        "123abc".consists(category: .latin) -> false
    ///        "abc".consists(category: .latin) -> true
    ///
    /// - Parameters:
    ///   - category: the unicode category(s) to check against (Variadic).
    /// - Returns: true if the String only contains characters in the input category(s).
    func consists(ofCategory category: RegexUnicodeCategory ...) -> Bool {
        let pattern = category.reduce(into: "") { $0 += "\\p{\($1.rawValue)}" }
        return self.range(of: "[^\(pattern)]", options: .regularExpression) == nil
    }
    
    /// LogosUtils: Check whether the String consists of (only contains) the characters in the input CharacterSet.
    ///
    ///        "123abc".consists(ofSet: .letters) -> false
    ///        "abc".consists(ofSet: .letters) -> true
    ///
    /// - Parameters:
    ///   - category: the set to check againt.
    /// - Returns: true if the String only contains characters in the input set.
    func consists(ofSet set: CharacterSet) -> Bool {
        return set.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func strippingDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    func whitelisting(set: CharacterSet) -> String {
        let filtered = self.unicodeScalars.filter { set.contains($0) }
        return String(filtered)
    }
}
