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
    
    func blacklisting(category: RegexUnicodeCategory ...) -> String {
        let pattern = category.reduce(into: "") { $0 += "\\p{\($1.rawValue)}" }
        return try! self.removing(pattern: "[\(pattern)]+")
    }
    
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
    
    func removing(pattern: String, options: NSRegularExpression.Options = []) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let range = NSMakeRange(0, self.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
    func replacing(pattern: String, withTemplate: String, options: NSRegularExpression.Options = []) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let range = NSMakeRange(0, self.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: withTemplate)
    }
    
    func splitting(byPattern pattern: String, options: NSRegularExpression.Options = []) throws -> [String] {
        let range = NSMakeRange(0, self.count)
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        
        var result = Array<String>()
        let matches = regex.matches(in: self, range: range)
        var lastRange = self.startIndex ..< self.startIndex
        for match in matches {
            // Extract the piece before the match
            let matchRange = Range<String.Index>(match.range, in: self)!
            let range = lastRange.upperBound ..< matchRange.lowerBound
            result.append(String(self[range]))
            lastRange = matchRange
            // Extract the groups
            for i in 1 ..< match.numberOfRanges {
                let range = match.range(at: i)
                if range.location != NSNotFound {
                    let stringRange = Range<String.Index>(range, in: self)!
                    result.append(String(self[stringRange]))
                }
            }
        }
        // Extract the final piece after the match
        let rest = String(self[lastRange.upperBound...])
        result.append(rest)
        return result
    }
    
    func strippingDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    func whitelisting(category: RegexUnicodeCategory ...) -> String {
        let pattern = category.reduce(into: "") { $0 += "\\p{\($1.rawValue)}" }
        return try! self.removing(pattern: "[^\(pattern)]+")
    }
    
    func whitelisting(set: CharacterSet) -> String {
        let filtered = self.unicodeScalars.filter { set.contains($0) }
        return String(filtered)
    }
}