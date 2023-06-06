//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
open class Lexeme: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	
	// MARK: Instance properties
	
	public var lexicalID: String = ""
	public var lexicalForm: String = ""
	public var gloss: String? = nil
	public var definition: String? = nil
	public var wordFormMorphologies: [Morphology]? = nil
	public var crasisLexicalIDs: [String]? = nil
	public var searchMatchingString: String = ""
	
	// MARK: Initilization
	
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
		crasisLexicalIDs = try! values.decodeIfPresent(forKey: .crasisLexicalIDs) ?? []
		searchMatchingString = try! values.decodeIfPresent(forKey: .searchMatchingString) ?? makeSearchMatchingString()
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
	
	// MARK: - Computed Properties
	
	public var description: String {
		return "\(lexicalID).\(gloss ?? "?")"
	}
	
	public var id: String {
		return lexicalID
	}
	
	public var isCrasis: Bool {
		return crasisLexicalIDs?.count ?? 0 > 0
	}
	
	// MARK: - Methods
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		// Required properties
		try! container.encode(lexicalID, forKey: .lexicalID)
		try! container.encode(lexicalForm, forKey: .lexicalForm)
		// Optional properties
		try! container.encodeIfPresent(gloss?.nonBlank, forKey: .gloss)
		try! container.encodeIfPresent(definition?.nonBlank, forKey: .definition)
		try! container.encodeIfPresent(wordFormMorphologies?.nonEmpty, forKey: .wordFormMorphologies)
		try! container.encodeIfPresent(crasisLexicalIDs?.nonEmpty, forKey: .crasisLexicalIDs)
		try! container.encodeIfPresent(searchMatchingString.nonBlank, forKey: .searchMatchingString)
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(lexicalID)
	}
	
	public func describeMorphology(using format: MorphologyDescriptionFormat) -> String? {
		guard let wordFormMorphologies else {
			return nil
		}
		let formattedMorphologies = wordFormMorphologies.compactMap { $0.describe(using: format) }
		return formattedMorphologies.joined(separator: "; ")
	}
	
	public func makeSearchMatchingString() -> String {
		return "#\(lexicalID);\(lexicalForm);\(gloss ?? "")"
	}
	
	// MARK: - Custom operator
	
	public static func == (lhs: Lexeme, rhs: Lexeme) -> Bool {
		lhs.id == rhs.id
	}
	
	// MARK: - Nested types
	
	public enum CodingKeys: String, CodingKey, CaseIterable {
		case lexicalID
		case lexicalForm
		case gloss
		case definition
		case wordFormMorphologies
		case crasisLexicalIDs
		case searchMatchingString
		
		public var stringValue: String {
			return rawValue
		}
	}
}

/*
 
 TODO:
 
 var abbreviated: Bool?
 var atticGreekForm: Bool?
 var conjunction: Bool?
 var interrogative: Bool?
 */

