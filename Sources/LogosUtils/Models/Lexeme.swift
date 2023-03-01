//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
public class Lexeme: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	
	public var lexicalID: String
	public var lexicalForm: String
	public var gloss: String? = nil
	public var definition: String? = nil
	public var wordFormMorphologies: [Morphology] = []
	public var crasisLexicalIDs: [String]? = nil
	public private(set) var searchMatchingString: String = ""
	public var tempProperties: [String: String] = [:]
	
	public init(lexicalID: String, lexicalForm: String) {
		self.lexicalID = lexicalID
		self.lexicalForm = lexicalForm
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
	
	func duplicate() -> Lexeme {
		let duplicate = Lexeme(lexicalID: lexicalID, lexicalForm: lexicalForm)
		duplicate.gloss = gloss
		duplicate.definition = definition
		duplicate.wordFormMorphologies = wordFormMorphologies
		duplicate.crasisLexicalIDs = crasisLexicalIDs
		duplicate.searchMatchingString = searchMatchingString
		return duplicate
	}
	
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
	
	func postprocess(language: Language) {
		
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

