//
//  String.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/13/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

public typealias StringFiltratingResult = (matching: String, notMatching: String)

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
    
    func filtrate(byRegex regex: NSRegularExpression) throws -> StringFiltratingResult {
        let nsString = NSString(string: self)
        let fullRange = NSRange(location: 0, length: self.utf16.count)
        var previousMatchRange = NSRange(location: 0, length: 0)
        
        var result: StringFiltratingResult = ("", "")
        for match in regex.matches(in: self, range: fullRange) {
            // Extract the piece before the match
            let precedingRange = NSRange(location: previousMatchRange.upperBound, length: match.range.lowerBound - previousMatchRange.upperBound)
            result.notMatching.append(nsString.substring(with: precedingRange))
            // Extract the match
            let range = match.range(at: 0)
            if range.location != NSNotFound {
                result.matching += nsString.substring(with: range)
            }
            previousMatchRange = match.range
        }
        // Extract the final piece
        let endingRange = NSRange(location: previousMatchRange.upperBound, length: fullRange.upperBound - previousMatchRange.upperBound)
        result.notMatching.append(nsString.substring(with: endingRange))
        return result
    }

    func matches(pattern: String, caseSensitive: Bool = true) -> Bool {
        let options: CompareOptions = caseSensitive ? [.regularExpression] : [.regularExpression, .caseInsensitive]
        return range(of: pattern, options: options, range: nil, locale: nil) != nil
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

    func replacing(pattern: String, withTemplate: String, options: NSRegularExpression.Options = []) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let range = NSRange(location: 0, length: self.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: withTemplate)
    }

    func splitting(byRegex regex: NSRegularExpression) throws -> [String] {
        var result = [String]()
        let nsString = NSString(string: self)
        let fullRange = NSRange(location: 0, length: self.utf16.count)
        var previousRange = NSRange(location: 0, length: 0)

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
