//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation
import GRDB

/// A struct representing a linguistic token.
///
/// This struct conforms to the `LinguisticUnit`, `Hashable`, `Equatable`, and `CustomStringConvertible` protocols.
@available(macOS 10.15, iOS 13.0, *)
public struct Token: LinguisticUnit, Hashable, Equatable, CustomStringConvertible {
	
	// MARK: - Properties
	
	/// The reference to the token.
	public var reference: TokenReference
	
	/// The related reference to another token.
	public var relatedReference: TokenReference?
	
	/// The surface form of the token.
	public var surfaceForm: String
	
	/// The lexical ID of the token.
	public var lexicalID: String?
	
	/// The morphologies associated with the token.
	public var morphologies: [Morphology]?
	
	/// The translation of the token.
	public var translation: String?
	
	// MARK: - Init
	
	public init(reference: TokenReference = .invalid, relatedReference: TokenReference? = nil, surfaceForm: String = "", lexicalID: String? = nil, morphologies: [Morphology]? = nil, translation: String? = nil) {
		self.reference = reference
		self.relatedReference = relatedReference
		self.surfaceForm = surfaceForm
		self.lexicalID = lexicalID
		self.morphologies = morphologies
		self.translation = translation
	}
	
	// MARK: - Computed Properties
	
	/// A textual description of the token.
	public var description: String {
		return "\(reference.decimalValue.description)-\(surfaceForm)"
	}
	
	/// The ID of the token.
	public var id: TokenReference {
		return reference
	}
	
	/// Checks whether the token is a punctuation token.
	public var isPunctuation: Bool {
		return morphologies?.first?.punctuation != nil || surfaceForm.consistsOfPunctuation
	}
	
	// MARK: - Methods
	
	/// Describes the morphologies of the token using the specified format.
	///
	/// - Parameter format: The format to use for describing the morphologies.
	/// - Returns: A string description of the token's morphologies, or `nil` if there are no morphologies.
	public func describeMorphology(using format: MorphologyDescriptionFormat) -> String? {
		guard let morphologies else {
			return nil
		}
		let formattedMorphologies = morphologies.compactMap { $0.describe(using: format) }
		return formattedMorphologies.joined(separator: "; ")
	}
	
	/// Generates a hash value for the token.
	///
	/// - Parameter hasher: The hasher to use for generating the hash value.
	public func hash(into hasher: inout Hasher) {
		hasher.combine(reference)
	}
	
	/// Validates the token and returns a validated instance.
	///
	/// - Returns: A validated and updated `Token` instance if the validation passes, otherwise `nil`.
	public func makeValidated() -> Token? {
		guard reference.isValid, !surfaceForm.isBlank else {
			return nil
		}
		return self
	}
	
	// MARK: - Static Members and Custom Operators
	
	public static let referenceColumnName = "reference"
	public static let relatedReferenceColumnName = "relatedReference"
	public static let surfaceFormColumnName = "surfaceForm"
	public static let lexicalIDColumnName = "lexicalID"
	public static let morphologiesColumnName = "morphologies"
	public static let translationColumnName = "translation"
	
	public static func setupTable(inDatabase database: Database) throws {
		try database.create(table: Token.databaseTableName) { table in
			table.primaryKey(referenceColumnName, .integer).notNull()
			table.column(relatedReferenceColumnName, .integer)
			table.column(surfaceFormColumnName, .text).notNull()
			table.column(lexicalIDColumnName, .text)
			table.column(morphologiesColumnName, .blob)
			table.column(translationColumnName, .text)
		}
	}
	
	/// Checks if two lexemes are equal by comparing their reference.
	///
	/// - Parameters:
	///   - lhs: The left-hand side token.
	///   - rhs: The right-hand side token.
	/// - Returns: `true` if the tokens have the same reference, otherwise `false`.
	public static func == (lhs: Token, rhs: Token) -> Bool {
		lhs.reference == rhs.reference
	}
}
