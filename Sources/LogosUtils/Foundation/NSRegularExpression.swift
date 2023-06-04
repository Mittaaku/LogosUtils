//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

public extension NSRegularExpression {
    
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
    
    func replace(string: String, withTemplate: String) -> String {
        let range = NSRange(location: 0, length: string.count)
        return stringByReplacingMatches(in: string, options: [], range: range, withTemplate: withTemplate)
    }
	
	/// Custom pattern matching operator for `NSRegularExpression` on the left-hand side.
	///
	/// - Parameters:
	///   - regex: The `NSRegularExpression` pattern to match against.
	///   - string: The string value to be checked for a match.
	/// - Returns: `true` if the `string` matches the specified `NSRegularExpression` pattern, `false` otherwise.
	static func ~=(regex: NSRegularExpression, string: String) -> Bool {
		let range = NSRange(location: 0, length: string.utf16.count)
		return regex.firstMatch(in: string, options: [], range: range) != nil
	}
}
#endif
