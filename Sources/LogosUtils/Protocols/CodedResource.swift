//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public protocol CodedResource: Decodable {
}

public extension CodedResource {
	
	static func decodeArray(fromJson json: String, inBundle bundle: Bundle? = nil) -> Array<Self> {
		return decode(fromJson: json)
	} 
	
	static func decodeArray(fromUrl url: URL) -> Array<Self> {
		return decode(fromUrl: url)
	}
	
	static func decodeElement(fromJson json: String, inBundle bundle: Bundle? = nil) -> Self {
		return decode(fromJson: json)
	}
	
	static func decodeElement(fromUrl url: URL) -> Self {
		return decode(fromUrl: url)
	}
	
	private static func decode<T: Decodable>(fromJson json: String, inBundle bundle: Bundle? = nil) -> T {
		let bundle = bundle ?? Bundle.main
		guard let url = bundle.url(forResource: json, withExtension: "json") else {
			fatalError("Json resource '\(json)' not found")
		}
		return decode(fromUrl: url)
	}
	
	private static func decode<T: Decodable>(fromUrl url: URL) -> T {
		do {
			let data = try Data(contentsOf: url)
			let decoder = JSONDecoder()
			let result = try decoder.decode(T.self, from: data)
			return result
			
		} catch let error {
			fatalError(error.localizedDescription)
		}
	}
}
