//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
open class Token: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	public var index: Int = 0
	public var reference: TokenReference = TokenReference()
	public var altReference: TokenReference? = nil
	public var relatedReference: TokenReference? = nil
	public var surfaceForm: String = ""
	public var lexicalID: String? = nil
	public var lexeme: Lexeme? = nil
	public var morphologies: [Morphology]? = nil
	public var translation: String? = nil
	
	public init() {
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
		morphologies = try! values.decodeIfPresent(forKey: .morphologies)
		translation = try! values.decodeIfPresent(forKey: .translation)
	}
	
	public init(duplicating token: Token) {
		index = token.index
		reference = token.reference
		altReference = token.altReference
		relatedReference = token.relatedReference
		surfaceForm = token.surfaceForm
		lexicalID = token.lexicalID
		morphologies = token.morphologies
		translation = token.translation
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
		return reference.rawValue == 0
	}
}

// MARK: - Methods
@available(iOS 16.0, macOS 13.0, *)
public extension Token {
	
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
		try! container.encodeIfPresent(morphologies?.nonEmpty, forKey: .morphologies)
		try! container.encodeIfPresent(translation, forKey: .translation)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(index)
	}
	
	func makeMorphologyDescription(withFormat format: Morphology.DescriptionFormat) -> String? {
		guard let morphologies else {
			return nil
		}
		let formattedMorphologies = morphologies.compactMap { $0.makeMorphologyDescription(withFormat: format) }
		return formattedMorphologies.joined(separator: "; ")
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
