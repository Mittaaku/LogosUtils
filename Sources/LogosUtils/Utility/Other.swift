//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 06/01/2023.
//

import Foundation

@_silgen_name("swift_EnumCaseName")
public func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?

public func getEnumCaseName<T>(for value: T) -> String? {
	if let stringPtr = _getEnumCaseName(value) {
		return String(validatingUTF8: stringPtr)
	}
	return nil
}
