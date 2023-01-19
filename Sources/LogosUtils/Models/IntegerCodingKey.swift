//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

@available(iOS 15.4, macOS 12.3, *)
public struct IntegerCodingKey: CodingKey {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init?(stringValue: String) {
		guard let intValue = Int(stringValue) else {
			return nil
		}
		rawValue = intValue
	}
	
	public init?(intValue: Int) {
		rawValue = intValue
	}
	
	public var stringValue: String {
		return String(rawValue)
	}
	
	public var intValue: Int? {
		return rawValue
	}
}
