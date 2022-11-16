//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public extension NSRegularExpression {
    
    static var digitStringPattern = NSRegularExpression(#"^\d+$"#)
    static var whitespaceStringPattern = NSRegularExpression(#"^\s+$"#)
    static var whitespaceOrEmptyStringPattern = NSRegularExpression(#"^\s*$"#)
	
	static var spacedGreekPattern = NSRegularExpression(#"^[\p{script=Greek}\s]+$"#)
	static var greekPattern = NSRegularExpression(#"^[\p{script=Greek}]+$"#)
	
	static var spacedHebrewPattern = NSRegularExpression(#"^[\p{script=Hebrew}\s]+$"#)
	static var hebrewPattern = NSRegularExpression(#"^[\p{script=Hebrew}]+$"#)
    
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
    
    func matches(string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
		let firstMatch = firstMatch(in: string, options: [], range: range)
        return firstMatch != nil
    }
    
    func matchesToArray(string: String) -> [[String]] {
        let nsString = string as NSString
        let results  = matches(in: string, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (1 ..< result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
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

    func firstMatch(in string: String,
                    options: MatchingOptions = [],
                    range: Range<String.Index>? = nil) -> NSTextCheckingResult? {
        let nsRange = NSRange(range ?? string.startIndex ..< string.endIndex, in: string)
        return firstMatch(in: string,
                          options: options,
                          range: nsRange)
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
        return result.filterOut(\.isBlank)
    }
}
