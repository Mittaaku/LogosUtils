//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

extension CaseIterable {
	
	static func makeDictionaryUsingValue<T: Hashable>(_ closure: (Self) throws -> T) rethrows -> [T: Self] {
		var result = [T: Self]()
		for enumCase in Self.allCases {
			let key = try closure(enumCase)
			result[key] = enumCase
		}
		return result
	}
	
	static func makeDictionaryUsingValue<T: Hashable>(_ closure: (Self) throws -> [T]) rethrows -> [T: Self] {
		var result = [T: Self]()
		for enumCase in Self.allCases {
			for key in try closure(enumCase) {
				result[key] = enumCase
			}
		}
		return result
	}
}
