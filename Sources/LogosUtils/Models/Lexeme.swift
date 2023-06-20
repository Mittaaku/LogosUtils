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
	
	/// The unique identifier of the lexeme.
	public var id: Int?
	
	/// The textual representation of the lexeme, also known as the lemma.
	public var lexicalForm: String
	
	/// The concordance ID of the lexeme.
	public var concordanceID: String?
	
	/// The gloss or brief explanation of the lexeme.
	public var gloss: String?
	
	/// The detailed definition of the lexeme.
	public var definition: String?
	
	/// The morphologies or grammatical features associated with the lexeme's different word forms.
	public var wordFormMorphologies = [Morphology]()
	
	/// The lexical IDs of the other lexemes which are combined to form this lexeme.
	public var crasisLexicalIDs = [Int]()
	
	/// The alternative forms of this lexeme.
	@TabSeparatedArray public var alternativeForms = [String]()
	
	/// The string used for searching and matching the lexeme.
	@TabSeparatedArray public private(set) var searchableStrings = [String]()
	
	// MARK: - Init
	
	init(lexicalForm: String, concordanceID: String? = nil, gloss: String? = nil, definition: String? = nil, wordFormMorphologies: [Morphology] = [], crasisLexicalIDs: [Int] = [], alternativeForms: [String] = []) {
		self.lexicalForm = lexicalForm
		self.concordanceID = concordanceID
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
	public func validated() -> Lexeme? {
		guard !lexicalForm.isBlank else {
			return nil
		}
		var result = self
		result.searchableStrings.append(lexicalForm)
		result.searchableStrings.append(gloss ?? "")
		result.searchableStrings.append(contentsOf: alternativeForms)
		return result
	}
	
	// MARK: - Static Members and Custom Operators
	
	public static let idColumn = Column(CodingKeys.id)
	public static let lexicalFormColumn = Column(CodingKeys.lexicalForm)
	public static let concordanceIDColumn = Column(CodingKeys.concordanceID)
	public static let glossColumn = Column(CodingKeys.gloss)
	public static let definitionColumn = Column(CodingKeys.definition)
	public static let wordFormMorphologiesColumn = Column(CodingKeys.wordFormMorphologies)
	public static let crasisLexicalIDsColumn = Column(CodingKeys.crasisLexicalIDs)
	public static let searchableStringsColumn = Column(CodingKeys.searchableStrings)
	public static let alternativeFormsColumn = Column(CodingKeys.alternativeForms)
	
	public static func setupTable(inDatabase database: Database) throws {
		try database.create(table: databaseTableName) { table in
			table.autoIncrementedPrimaryKey(idColumn.name)
			table.column(lexicalFormColumn.name, .text).notNull().unique() // Enforce uniqueness on "lexicalForm" column
			table.column(concordanceIDColumn.name, .text)
			table.column(glossColumn.name, .text)
			table.column(definitionColumn.name, .text)
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
		lhs.id == rhs.id
	}
}
