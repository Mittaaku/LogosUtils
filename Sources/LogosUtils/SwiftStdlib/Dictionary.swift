//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

public extension Dictionary where Value: Hashable {
	
	/// Returns a new dictionary with the keys and values flipped.
	/// - Returns: A dictionary with the values as keys and the keys as values.
	func flipped() -> [Value: Key] {
		return reduce(into: [:]) { $0[$1.value] = $1.key }
	}
}

public extension Dictionary where Value: Sequence, Value.Element: Hashable {
	
	/// Returns a new dictionary with the keys and elements of the sequences flipped.
	/// - Returns: A dictionary with the elements as keys and the keys as values.
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
	
	/// Creates a unique key from a camel case string.
	/// - Parameter string: The input string in camel case.
	/// - Returns: A unique key derived from the input string.
	/// - Precondition: The input string must not be empty.
	/// - Precondition: The input string must be in camel case.
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
	
	/// Returns a new dictionary by creating duplicate keys for various cases alongside the original key for each pair.
	/// - Returns: A dictionary with duplicate keys and the original keys.
	func duplicatingCaseKeys() -> Self {
		var result = [Key: Value]()
		for pair in self {
			result[pair.key.lowercased()] = pair.value
			result[pair.key.camelcased()] = pair.value
		}
		for pair in self {
			result[pair.key] = pair.value
		}
		return result
	}
}
