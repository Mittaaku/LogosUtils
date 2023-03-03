//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
public class Token: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	public var index: Int = 0
	public var reference: TokenReference
	public var altReference: TokenReference? = nil
	public var relatedReference: TokenReference? = nil
	public var surfaceForm: String = ""
	public var lexicalID: String? = nil
	public var lexeme: Lexeme? = nil
	public var morphologies: [Morphology] = []
	public var translation: String? = nil
	public var tempProperties: [String: String] = [:]
	
	public init(reference: TokenReference) {
		self.reference = reference
	}
	
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		// Required properties
		index = try! values.decode(forKey: .index)
		reference = try! values.decode(forKey: .reference)
		surfaceForm = try! values.decode(forKey: .surfaceForm)
		// Optional properties
		altReference = try! values.decodeIfPresent(forKey: .altReference)
		relatedReference = try! values.decodeIfPresent(forKey: .relatedReference)
		lexicalID = try! values.decodeIfPresent(forKey: .lexicalID)
		morphologies = try! values.decodeIfPresent(forKey: .morphologies) ?? []
		translation = try! values.decodeIfPresent(forKey: .translation)
	}
}

// MARK: - Computed Properties
@available(iOS 16.0, macOS 13.0, *)
public extension Token {
	var description: String {
		return "\(reference.debugDescription) \(surfaceForm)"
	}
	
	var id: Int {
		return index
	}
	
	var isPlaceholder: Bool {
		return index == 0
	}
}

// MARK: - Methods
@available(iOS 16.0, macOS 13.0, *)
public extension Token {
	
	func duplicate() -> Token {
		let duplicate = Token(reference: reference)
		duplicate.index = index
		duplicate.altReference = altReference
		duplicate.relatedReference = relatedReference
		duplicate.surfaceForm = surfaceForm
		duplicate.lexicalID = lexicalID
		duplicate.morphologies = morphologies
		duplicate.translation = translation
		duplicate.tempProperties = tempProperties
		return duplicate
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		// Required properties
		try! container.encode(index, forKey: .index)
		try! container.encode(reference, forKey: .reference)
		try! container.encode(surfaceForm, forKey: .surfaceForm)
		// Optional properties
		try! container.encodeIfPresent(altReference, forKey: .altReference)
		try! container.encodeIfPresent(relatedReference, forKey: .relatedReference)
		try! container.encodeIfPresent(lexicalID, forKey: .lexicalID)
		try! container.encodeIfPresent(morphologies.nonEmpty, forKey: .morphologies)
		try! container.encodeIfPresent(translation, forKey: .translation)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(index)
	}
}

// MARK: - Functions and static variables
@available(iOS 16.0, macOS 13.0, *)
public extension Token {
	
	static func == (lhs: Token, rhs: Token) -> Bool {
		lhs.index == rhs.index
	}
}

// MARK: - CodingKeys struct
@available(iOS 16.0, macOS 13.0, *)
public extension Token {
	
	enum CodingKeys: String, CodingKey, CaseIterable {
		case index
		case reference
		case altReference
		case relatedReference
		case lexicalID
		case surfaceForm
		case morphologies
		case translation
		
		public var stringValue: String {
			return CodingKeys.stringKeyByCase[self]!
		}
		
		static var stringKeyByCase = makeShortenedKeysByCase()
	}
}
