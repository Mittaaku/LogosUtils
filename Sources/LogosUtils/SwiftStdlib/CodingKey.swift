//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

public extension CodingKey where Self: Hashable & CaseIterable & RawRepresentable, RawValue == String {
	
	static func makeShortenedKeysByCase() -> [Self: String] {
		var uniqueKeys = Set<String>()
		var result = [Self: String]()
		for enumCase in Self.allCases {
			let key = uniqueKeys.makeUniqueElement(fromString: enumCase.rawValue)!
			uniqueKeys.insert(key)
			result[enumCase] = key
		}
		return result
	}
}
