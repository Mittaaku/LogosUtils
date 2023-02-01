//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Functions
@available(iOS 16.0, macOS 13.0, *)
public extension Regex {
	static func ~=(regex: Regex, string: String) -> Bool {
		return string.starts(with: regex)
	}
}
