//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension RangeReplaceableCollection {

	@discardableResult mutating func appendIfNotNil(_ value: Element?) -> Bool {
		guard let value else {
			return false
		}
		self.append(value)
		return true
	}
}

public extension RangeReplaceableCollection where Element: Equatable {
	
	@discardableResult mutating func appendIfNoneEquates(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
		if let index = firstIndex(of: element) {
			return (false, self[index])
		} else {
			append(element)
			return (true, element)
		}
	}
}

