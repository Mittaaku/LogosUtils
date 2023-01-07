//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

public extension Dictionary where Value: Hashable {
	
	func flipped() -> [Value: Key] {
		return reduce(into: [Value: Key]()) {
			$0[$1.value] = $1.key
		}
	}
}

public extension Dictionary where Value: Sequence, Value.Element: Hashable {
	
	func sequentiallyFlipped() -> [Value.Element: Key] {
		var result = [Value.Element: Key]()
		for pair in self {
			for element in pair.value {
				result[element] = pair.key
			}
		}
		return result
	}
}
