//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

/// The `Token` protocol represents a token.
///
/// Tokens are individual units of information or entities within a larger text. This class provides properties and methods to store and manage token-related data.
///
/// Use the `Token` class to represent tokens and perform operations related to tokenization, encoding, decoding, and comparison.
@available(macOS 10.15, iOS 13.0, *)
public protocol Token: Encodable, Hashable, Equatable, CustomStringConvertible, Identifiable {

	/// The primary reference associated with the token, which also serves as the `id`.
	var reference: TokenReference { get }
	
	/// A related reference associated with the token, if any.
	var relatedReference: TokenReference? { get }
	
	/// The surface form of the token (the actual text).
	var surfaceForm: String { get }
	
	/// The lexical ID of the token, if available.
	var lexicalID: String? { get }
	
	/// The morphologies associated with the token, if any.
	var morphologies: [Morphology]? { get }
	
	/// The translation of the token, if available.
	var translation: String? { get }
}

@available(macOS 10.15, iOS 13.0, *)
public extension Token {
	
	// MARK: - Computed properties
	
	var description: String {
		return "\(reference.decimalValue.description)-\(surfaceForm)"
	}
	
	var id: TokenReference {
		return reference
	}
	
	// MARK: - Methods
	
	func describeMorphology(using format: MorphologyDescriptionFormat) -> String? {
		guard let morphologies else {
			return nil
		}
		let formattedMorphologies = morphologies.compactMap { $0.describe(using: format) }
		return formattedMorphologies.joined(separator: "; ")
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: TokenCodingKeys.self)
		// Required properties
		try! container.encode(reference, forKey: .reference)
		try! container.encode(surfaceForm, forKey: .surfaceForm)
		// Optional properties
		try! container.encodeIfPresent(relatedReference, forKey: .relatedReference)
		try! container.encodeIfPresent(lexicalID, forKey: .lexicalID)
		try! container.encodeIfPresent(morphologies?.nonEmpty, forKey: .morphologies)
		try! container.encodeIfPresent(translation, forKey: .translation)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(reference)
	}
	
	// MARK: - Custom operators
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.reference == rhs.reference
	}
}

enum TokenCodingKeys: String, CodingKey, CaseIterable {
	case reference
	case relatedReference
	case lexicalID
	case surfaceForm
	case morphologies
	case translation
	
	public var stringValue: String {
		return rawValue
	}
}
