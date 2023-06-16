//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation
import GRDB

public protocol GrammemeType: Codable, Equatable, Hashable, LosslessStringConvertible, RawRepresentable, DatabaseValueConvertible where RawValue == Int {
	
	init?(abbreviation: String)
	
	var abbreviation: String { get }
	
	var fullName: String { get }
}

public extension GrammemeType {
	
	init?(optionalAbbreviation: String?) {
		guard let optionalAbbreviation else {
			return nil
		}
		self.init(abbreviation: optionalAbbreviation)
	}
	
	init?(_ description: String) {
		self.init(abbreviation: description)
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(String.self)
		guard let result = Self.init(value) else {
			preconditionFailure("Invalid \(Self.self) value '\(value)'.")
		}
		self = result
	}
	
	var description: String {
		return abbreviation
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(abbreviation)
	}
}
