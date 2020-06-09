//
//  String.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/13/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

import Foundation

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

    func filtering(pattern: String, options: NSRegularExpression.Options = []) throws -> String {
        let nsString = NSString(string: self)
        let fullRange = NSRange(location: 0, length: self.utf16.count)
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        var result = ""
        for match in regex.matches(in: self, range: fullRange) {
            for groupIndex in (1 ..< match.numberOfRanges) {
                let range = match.range(at: groupIndex)
                if range.location != NSNotFound {
                    result += nsString.substring(with: range)
                }
            }
        }
        return result
    }

    func filtering(set: CharacterSet) -> String {
        let filtered = self.unicodeScalars.filter { set.contains($0) }
        return String(filtered)
    }

    func matches(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        let options: CompareOptions = caseSensitive ? [.regularExpression] : [.regularExpression, .caseInsensitive]
        return range(of: pattern, options: options, range: nil, locale: nil) != nil
    }
    
    func matchesFully(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        let options: CompareOptions = caseSensitive ? [.regularExpression] : [.regularExpression, .caseInsensitive]
        guard let range = self.range(of: pattern, options: options) else {
            return false
        }
        return self.startIndex ..< self.endIndex == range
    }

    func replacing(pattern: String, withTemplate: String, options: NSRegularExpression.Options = []) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let range = NSRange(location: 0, length: self.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: withTemplate)
    }

    func splitting(byPattern pattern: String, options: NSRegularExpression.Options = []) throws -> [String] {
        var result = [String]()

        let nsString = NSString(string: self)
        let fullRange = NSRange(location: 0, length: self.utf16.count)
        var previousRange = NSRange(location: 0, length: 0)

        let regex = try NSRegularExpression(pattern: pattern, options: [])
        for match in regex.matches(in: self, range: fullRange) {
            // Extract the piece before the match
            let precedingRange = NSRange(location: previousRange.upperBound, length: match.range.lowerBound - previousRange.upperBound)
            result.append(nsString.substring(with: precedingRange))
            // Extract the groups
            for i in 1 ..< match.numberOfRanges {
                let range = match.range(at: i)
                if range.location != NSNotFound {
                    result.append(nsString.substring(with: range))
                }
            }
            previousRange = match.range
        }
        // Extract the final piece
        let endingRange = NSRange(location: previousRange.upperBound, length: fullRange.upperBound - previousRange.upperBound)
        result.append(nsString.substring(with: endingRange))
        return result.reject(\.isBlank)
    }

    func strippingDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}
