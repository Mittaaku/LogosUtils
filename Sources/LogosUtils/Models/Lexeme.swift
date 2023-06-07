//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

/// A protocol representing a lexeme, which is a basic unit of a language.
///
/// A lexeme typically corresponds to a word or a phrase with a specific meaning.
///
/// The `Lexeme` protocol inherits from several other protocols, including `Encodable`, `Hashable`,
/// `Equatable`, `CustomStringConvertible`, and `Identifiable`, which provide additional functionality.
@available(macOS 10.15, iOS 13.0, *)
public protocol Lexeme: Encodable, Hashable, Equatable, CustomStringConvertible, Identifiable {
	
	/// The unique identifier of the lexeme.
	var lexicalID: String { get }
	
	/// The textual representation of the lexeme.
	var lexicalForm: String { get }
	
	/// The gloss or brief explanation of the lexeme.
	var gloss: String? { get }
	
	/// The detailed definition of the lexeme.
	var definition: String? { get }
	
	/// The morphologies or grammatical features associated with the lexeme's different word forms.
	var wordFormMorphologies: [Morphology]? { get }
	
	/// The lexical IDs of other lexemes that combine with this lexeme to form a compound word.
	var crasisLexicalIDs: [String]? { get }
	
	/// The string used for searching and matching the lexeme.
	var searchMatchingString: String { get }
}

@available(macOS 10.15, iOS 13.0, *)
extension Lexeme {
	
	// MARK: - Computed Properties
	
	public var description: String {
		return "\(lexicalID)-\(gloss ?? "?")"
	}
	
	public var id: String {
		return lexicalID
	}
	
	public var isCrasis: Bool {
		return crasisLexicalIDs?.count ?? 0 > 0
	}
	
	// MARK: - Methods
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: LexemeCodingKeys.self)
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
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}

public enum LexemeCodingKeys: String, CodingKey, CaseIterable {
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
