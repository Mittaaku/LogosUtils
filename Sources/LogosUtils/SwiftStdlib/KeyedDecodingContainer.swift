//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 27/02/2023.
//

import Foundation

extension KeyedDecodingContainer {
	
	func decode<T>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable {
		return try decode(T.self, forKey: key)
	}
	
	func decodeIfPresent<T>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
		return try decodeIfPresent(T.self, forKey: key)
	}
}
