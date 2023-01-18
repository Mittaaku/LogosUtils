//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

public extension Dictionary where Value: Hashable {
	
	func flipped() -> [Value: Key] {
		return reduce(into: [:]) { $0[$1.value] = $1.key }
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

public extension Dictionary where Key == String {
	func makeUniqueKey(fromCamelCaseString string: String) -> String {
		assert(!string.isEmpty, "Input string cannot be empty")
		
		var key = ""
		
		let first = string.first!
		assert(!first.isUppercase, "Input string is not camel case")
		key.append(first)
		
		for character in string {
			if character.isUppercase {
				key.append(character.lowercased())
			} else if character.isNumber {
				key.append(character)
			}
		}
		
		let keyPrefix = key
		var counter = 1
		while self[key] != nil {
			key = "\(keyPrefix)\(counter)"
			counter += 1
		}
		
		return key
	}
}
