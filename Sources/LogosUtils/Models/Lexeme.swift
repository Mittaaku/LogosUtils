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
	
	/// The unique identifier of the lexeme in the database, which will be the Strongs Number in Biblical Hebrew and Koine Greek lexemes.
	public var lexicalID: String
	
	/// The textual representation of the lexeme, also known as the lemma.
	public var lexicalForm: String
	
	/// The gloss or brief explanation of the lexeme, if any.
	public var gloss: String
	
	/// The detailed definition of the lexeme, if any.
	public var definition: String
	
	/// The morphologies or grammatical features associated with the lexeme's different word forms.
	public var wordFormMorphologies: [Morphology]
	
	/// The lexical IDs of the other lexemes which are combined to form this lexeme.
	public var crasisLexicalIDs: [String]
	
	/// The alternative forms of this lexeme.
	@TabSeparatedArray public var alternativeForms: [String]
	
	/// The string used for searching and matching the lexeme.
	@TabSeparatedArray public private(set) var searchableStrings = [String]()
	
	// MARK: - Init
	
	public init(lexicalID: String = "", lexicalForm: String = "", gloss: String = "", definition: String = "", wordFormMorphologies: [Morphology] = [], crasisLexicalIDs: [Int] = [], alternativeForms: [String] = []) {
		self.lexicalID = lexicalID
		self.lexicalForm = lexicalForm
		self.gloss = gloss
		self.definition = definition
		self.wordFormMorphologies = wordFormMorphologies
		self.crasisLexicalIDs = crasisLexicalIDs
		self.alternativeForms = alternativeForms
	}
	
	// MARK: - Computed Properties
	
	/// A textual description of the lexeme.
	public var description: String {
		return "(Lexeme: \(lexicalForm))"
	}
	
	/// The unique identifier of the lexeme in the database, which will be the Strongs Number in Biblical Hebrew and Koine Greek lexemes. This property is an alias for the original property `lexicalID`.
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
		hasher.combine(lexicalForm)
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
	public func makeValidated() -> Lexeme? {
		guard !lexicalForm.isBlank else {
			return nil
		}
		var result = self
		result.searchableStrings.append(lexicalForm)
		if !gloss.isBlank {
			result.searchableStrings.append(gloss)
		}
		result.searchableStrings.append(contentsOf: alternativeForms)
		return result
	}
	
	// MARK: - Static Members and Custom Operators
	
	public static let lexicalIDColumn = Column(CodingKeys.lexicalID)
	public static let lexicalFormColumn = Column(CodingKeys.lexicalForm)
	public static let glossColumn = Column(CodingKeys.gloss)
	public static let definitionColumn = Column(CodingKeys.definition)
	public static let wordFormMorphologiesColumn = Column(CodingKeys.wordFormMorphologies)
	public static let crasisLexicalIDsColumn = Column(CodingKeys.crasisLexicalIDs)
	public static let searchableStringsColumn = Column(CodingKeys.searchableStrings)
	public static let alternativeFormsColumn = Column(CodingKeys.alternativeForms)
	
	public static func setupTable(inDatabase database: Database) throws {
		try database.create(table: databaseTableName) { table in
			table.primaryKey(lexicalIDColumn.name, .text).notNull()
			table.column(lexicalFormColumn.name, .text).notNull()
			table.column(glossColumn.name, .text).notNull()
			table.column(definitionColumn.name, .text).notNull()
			table.column(wordFormMorphologiesColumn.name, .blob)
			table.column(crasisLexicalIDsColumn.name, .blob)
			table.column(searchableStringsColumn.name, .text).notNull()
			table.column(alternativeFormsColumn.name, .text).notNull()
		}
	}
	
	/// Checks if two lexemes are equal by comparing their identifiers.
	///
	/// - Parameters:
	///     - lhs: The left-hand side lexeme.
	///     - rhs: The right-hand side lexeme.
	/// - Returns: `true` if the lexemes have the same identifier, otherwise `false`.
	public static func == (lhs: Lexeme, rhs: Lexeme) -> Bool {
		lhs.lexicalID == rhs.lexicalID
	}
}
