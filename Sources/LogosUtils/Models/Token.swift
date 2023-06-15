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
	public var relatedReference: TokenReference? = nil
	
	/// The surface form of the token.
	public var surfaceForm: String
	
	/// The lexical ID of the token.
	public var lexicalID: String? = nil
	
	/// The morphologies associated with the token.
	public var morphologies: [Morphology]? = nil
	
	/// The translation of the token.
	public var translation: String? = nil
	
	// MARK: - Computed Properties
	
	/// A textual description of the token.
	public var description: String {
		return "\(reference.decimalValue.description)-\(surfaceForm)"
	}
	
	/// The ID of the token.
	public var id: TokenReference {
		return reference
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
	public func validated() -> Token? {
		return self
	}
	
	// MARK: - Custom Operators
	
	/// Checks if two tokens are equal.
	///
	/// - Parameters:
	///   - lhs: The left-hand side token.
	///   - rhs: The right-hand side token.
	/// - Returns: `true` if the tokens are equal, otherwise `false`.
	public static func == (lhs: Token, rhs: Token) -> Bool {
		lhs.reference == rhs.reference
	}
}
