//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation
import GRDB

/// A struct representing a lexeme or lemma.
@available(macOS 10.15, iOS 13.0, *)
public struct Lexeme: LinguisticUnit, Equatable, Hashable, CustomStringConvertible {
	
	// MARK: - Properties
	
	/// The unique identifier of the lexeme, which also functions as the `id`.
	public var lexicalID: String
	
	/// The textual representation of the lexeme, also known as the lemma.
	public var lexicalForm: String
	
	/// The gloss or brief explanation of the lexeme.
	public var gloss: String?
	
	/// The detailed definition of the lexeme.
	public var definition: String?
	
	/// The morphologies or grammatical features associated with the lexeme's different word forms.
	public var wordFormMorphologies: [Morphology] = []
	
	/// The lexical IDs of other lexemes that combine with this lexeme to form a compound word.
	public var crasisLexicalIDs: [String] = []
	
	/// The string used for searching and matching the lexeme.
	public var searchMatchingString: String = ""
	
	// MARK: - Computed Properties
	
	/// A textual description of the lexeme.
	public var description: String {
		return "\(lexicalID)-\(gloss ?? "?")"
	}
	
	/// The unique identifier of the lexeme.
	public var id: String {
		return lexicalID
	}
	
	/// Checks if the lexeme is a compound word.
	public var isCrasis: Bool {
		return !crasisLexicalIDs.isEmpty
	}
	
	// MARK: - Methods
	
	/// Generates a hash value for the lexeme.
	///
	/// - Parameters:
	///     - hasher: The hasher to use in the hashing process.
	public func hash(into hasher: inout Hasher) {
		hasher.combine(lexicalID)
	}
	
	/// Generates a description of the lexeme's morphology using the specified format.
	///
	/// - Parameters:
	///     - format: The format to use for describing the morphology.
	/// - Returns: A formatted description of the lexeme's morphology, or `nil` if there are no morphologies.
	public func describeMorphology(using format: MorphologyDescriptionFormat) -> String? {
		let formattedMorphologies = wordFormMorphologies.map { $0.describe(using: format) }
		return formattedMorphologies.joined(separator: "; ")
	}
	
	/// Validates the lexeme and returns one with updated properties.
	///
	/// - Returns: A validated and updated `Lexeme` instance if the validation passes, otherwise `nil`.
	public func validated() -> Lexeme? {
		guard !lexicalID.isEmpty, !lexicalForm.isEmpty else {
			return nil
		}
		var result = self
		result.searchMatchingString = "#\(lexicalID);\(lexicalForm);\(gloss ?? "")"
		return result
	}
	
	// MARK: - Custom operators
	
	/// Checks if two lexemes are equal by comparing their identifiers.
	///
	/// - Parameters:
	///     - lhs: The left-hand side lexeme.
	///     - rhs: The right-hand side lexeme.
	/// - Returns: `true` if the lexemes have the same identifier, otherwise `false`.
	public static func == (lhs: Lexeme, rhs: Lexeme) -> Bool {
		lhs.id == rhs.id
	}
}
