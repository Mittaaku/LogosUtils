//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
struct Lexeme: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	private(set) var lexicalID: String
	private(set) var lexicalForm: String
	var gloss: String? = nil
	var definition: String? = nil
	var wordFormMorphologies: [Morphology] = []
	var crasisLexicalIDs: [String]? = nil
	private(set) var searchMatchingString: String = ""
	var extraProperties: [String: String] = [:]
	
	init(lexicalID: String, lexicalForm: String) {
		self.lexicalID = lexicalID
		self.lexicalForm = lexicalForm
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		// Required properties
		lexicalID = try! values.decode(forKey: .lexicalID)
		lexicalForm = try! values.decode(forKey: .lexicalForm)
		// Optional properties
		gloss = try! values.decodeIfPresent(forKey: .gloss)
		definition = try! values.decodeIfPresent(forKey: .definition)
		wordFormMorphologies = try! values.decodeIfPresent(forKey: .wordFormMorphologies) ?? []
		crasisLexicalIDs = try! values.decodeIfPresent(forKey: .crasisLexicalIDs)
		extraProperties = try! values.decodeIfPresent(forKey: .extraProperties) ?? [:]
		// Non-encoded properties
		searchMatchingString = "#\(lexicalID);\(lexicalForm);\(gloss ?? "")"
	}
}

// MARK: - Computed Properties
@available(iOS 16.0, macOS 13.0, *)
extension Lexeme {
	
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
extension Lexeme {
	
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
		try! container.encodeIfPresent(extraProperties.nonEmpty, forKey: .extraProperties)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(lexicalID)
	}
}

// MARK: - Functions
@available(iOS 16.0, macOS 13.0, *)
extension Lexeme {
	
	static func == (lhs: Lexeme, rhs: Lexeme) -> Bool {
		lhs.id == rhs.id
	}
}

// MARK: - CodingKeys struct
@available(iOS 16.0, macOS 13.0, *)
extension Lexeme {
	enum CodingKeys: String, CodingKey, CaseIterable {
		case lexicalID
		case lexicalForm
		case gloss
		case definition
		case wordFormMorphologies
		case crasisLexicalIDs
		case extraProperties
		
		var stringValue: String {
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
