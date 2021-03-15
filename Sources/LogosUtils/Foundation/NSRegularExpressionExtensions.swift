//
//  File.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/9/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

import Foundation

public extension NSRegularExpression {
    
    enum UnicodeCategory: String {
        case han = "Han" // Chinese Hanzi, Japanese Kanji, and Korean Hanja.
        case hiragana = "Hiragana"
        case katakana = "Katakana"
        case latin = "Latin"
        case letter = "L"
        case letterLowercase = "Li"
        case letterUppercase = "Lu"
        case number = "N"
        case numberDecimalDigit = "Nd"
        case whitespace = "Whitespace"
    }
    
    typealias DividedResults = (matching: String, notMatching: String)
    
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func divide(string: String) -> DividedResults {
        let nsString = NSString(string: string)
        let fullRange = NSRange(location: 0, length: string.utf16.count)
        var previousMatchRange = NSRange(location: 0, length: 0)

        var divided: DividedResults = ("", "")
        for match in matches(in: string, range: fullRange) {
            // Extract the piece before the match
            let precedingRange = NSRange(location: previousMatchRange.upperBound, length: match.range.lowerBound - previousMatchRange.upperBound)
            divided.notMatching.append(nsString.substring(with: precedingRange))
            // Extract the match
            let range = match.range(at: 0)
            if range.location != NSNotFound {
                divided.matching += nsString.substring(with: range)
            }
            previousMatchRange = match.range
        }
        // Extract the final piece
        let endingRange = NSRange(location: previousMatchRange.upperBound, length: fullRange.upperBound - previousMatchRange.upperBound)
        divided.notMatching.append(nsString.substring(with: endingRange))
        return divided
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func filter(string: String) -> String {
        let nsString = NSString(string: string)
        let fullRange = NSRange(location: 0, length: string.utf16.count)
        var result = ""
        for match in matches(in: string, range: fullRange) {
            let range = match.range(at: 0)
            if range.location != NSNotFound {
                result += nsString.substring(with: range)
            }
        }
        return result
    }
    
    func replace(string: String, withTemplate: String) -> String {
        let range = NSRange(location: 0, length: string.count)
        return stringByReplacingMatches(in: string, options: [], range: range, withTemplate: withTemplate)
    }
    
    func split(string: String) -> [String] {
        var result = [String]()
        let nsString = NSString(string: string)
        let fullRange = NSRange(location: 0, length: string.utf16.count)
        var previousRange = NSRange(location: 0, length: 0)

        for match in matches(in: string, range: fullRange) {
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
}
