//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@propertyWrapper
public struct TabSeparatedArray: Codable {
	private var storage: [String]
	
	public var wrappedValue: [String] {
		get {
			return storage
		}
		set {
			storage = newValue
		}
	}
	
	public var projectedValue: String {
		return storage.joined(separator: "\t")
	}
	
	public init(wrappedValue: [String]) {
		self.storage = TabSeparatedArray.sanitizeValues(wrappedValue)
	}
	
	public init(projectedValue: String) {
		let sanitizedValues = TabSeparatedArray.sanitizeValues(projectedValue.components(separatedBy: "\t"))
		self.storage = sanitizedValues
	}
	
	private static func sanitizeValues(_ values: [String]) -> [String] {
		return values.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { !$0.isEmpty }
	}
	
	// MARK: - Codable
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let projectedValue = try container.decode(String.self)
		self.init(projectedValue: projectedValue)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(projectedValue)
	}
}
