//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 23/01/2023.
//

import Foundation

extension CaseIterable {
	
	static func makeDictionaryByValue<T: Hashable>(_ closure: (Self) throws -> T) rethrows -> [T: Self] {
		var result = [T: Self]()
		for enumCase in Self.allCases {
			let key = try closure(enumCase)
			result[key] = enumCase
		}
		return result
	}
	
	static func makeDictionaryByValue<T: Hashable>(_ closure: (Self) throws -> [T]) rethrows -> [T: Self] {
		var result = [T: Self]()
		for enumCase in Self.allCases {
			for key in try closure(enumCase) {
				result[key] = enumCase
			}
		}
		return result
	}
}
