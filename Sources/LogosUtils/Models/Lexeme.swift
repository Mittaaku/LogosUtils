//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
open class Lexeme: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	public var lexicalID: String = ""
	public var lexicalForm: String = ""
	public var gloss: String? = nil
	public var definition: String? = nil
	public var wordFormMorphologies: [Morphology] = []
	public var crasisLexicalIDs: [String]? = nil
	public private(set) var searchMatchingString: String = ""
	
	public init() {
	}
	
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		// Required properties
		lexicalID = try! values.decode(forKey: .lexicalID)
		lexicalForm = try! values.decode(forKey: .lexicalForm)
		// Optional properties
		gloss = try! values.decodeIfPresent(forKey: .gloss)
		definition = try! values.decodeIfPresent(forKey: .definition)
		wordFormMorphologies = try! values.decodeIfPresent(forKey: .wordFormMorphologies) ?? []
		crasisLexicalIDs = try! values.decodeIfPresent(forKey: .crasisLexicalIDs)
	}
	
	public init(duplicating lexeme: Lexeme) {
		lexicalID = lexeme.lexicalID
		lexicalForm = lexeme.lexicalForm
		gloss = lexeme.gloss
		definition = lexeme.definition
		wordFormMorphologies = lexeme.wordFormMorphologies
		crasisLexicalIDs = lexeme.crasisLexicalIDs
		searchMatchingString = lexeme.searchMatchingString
	}
}

// MARK: - Computed Properties
@available(iOS 16.0, macOS 13.0, *)
public extension Lexeme {
	
	var description: String {
		return "\(lexicalID).\(gloss ?? "?")"
	}
	
	var id: String {
		return lexicalID
	}
	
	var isCrasis: Bool {
		return crasisLexicalIDs != nil
	}
}

// MARK: - Methods
@available(iOS 16.0, macOS 13.0, *)
public extension Lexeme {
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		// Required properties
		try! container.encode(lexicalID, forKey: .lexicalID)
		try! container.encode(lexicalForm, forKey: .lexicalForm)
		// Optional properties
		try! container.encodeIfPresent(gloss, forKey: .gloss)
		try! container.encodeIfPresent(definition, forKey: .definition)
		try! container.encodeIfPresent(wordFormMorphologies.nonEmpty, forKey: .wordFormMorphologies)
		try! container.encodeIfPresent(crasisLexicalIDs, forKey: .crasisLexicalIDs)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(lexicalID)
	}
}

// MARK: - Functions
@available(iOS 16.0, macOS 13.0, *)
public extension Lexeme {
	
	static func == (lhs: Lexeme, rhs: Lexeme) -> Bool {
		lhs.id == rhs.id
	}
}

// MARK: - CodingKeys struct
@available(iOS 16.0, macOS 13.0, *)
public extension Lexeme {
	enum CodingKeys: String, CodingKey, CaseIterable {
		case lexicalID
		case lexicalForm
		case gloss
		case definition
		case wordFormMorphologies
		case crasisLexicalIDs
		
		public var stringValue: String {
			return CodingKeys.stringKeyByCase[self]!
		}
		
		static var stringKeyByCase = makeShortenedKeysByCase()
	}
}


/*
 
 TODO:
 
 var abbreviated: Bool?
 var atticGreekForm: Bool?
 var conjunction: Bool?
 var interrogative: Bool?
 */

