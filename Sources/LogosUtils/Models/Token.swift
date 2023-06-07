//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

/// The `Token` class represents a token.
///
/// Tokens are individual units of information or entities within a larger text. This class provides properties and methods to store and manage token-related data.
///
/// Use the `Token` class to represent tokens and perform operations related to tokenization, encoding, decoding, and comparison.
struct Token: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	
	// MARK: - Instance properties
	
	/// The index of the token, which also serves as the id.
	public var index: Int = 0
	
	/// The primary reference associated with the token.
	public var reference: TokenReference = TokenReference()
	
	/// A related reference associated with the token, if any.
	public var relatedReference: TokenReference? = nil
	
	/// The surface form of the token (the actual text).
	public var surfaceForm: String = ""
	
	/// The lexical ID of the token, if available.
	public var lexicalID: String? = nil
	
	/// The lexeme associated with the token, if any.
	public var lexeme: Lexeme? = nil
	
	/// The morphologies associated with the token, if any.
	public var morphologies: [Morphology]? = nil
	
	/// The translation of the token, if available.
	public var translation: String? = nil
	
	// MARK: - Initialization
	
	/// Creates a new `Token` instance.
	public init() {
	}
	
	///  Creates a new `Token` instance by decoding from the given decoder.
	///
	///  - Parameter decoder: The decoder to read data from.
	///  - Throws: An error if the decoding process fails or if required properties are missing.
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		// Required properties
		index = try! values.decode(forKey: .index)
		reference = try! values.decode(forKey: .reference)
		surfaceForm = try! values.decode(forKey: .surfaceForm)
		// Optional properties
		relatedReference = try! values.decodeIfPresent(forKey: .relatedReference)
		lexicalID = try! values.decodeIfPresent(forKey: .lexicalID)
		morphologies = try! values.decodeIfPresent(forKey: .morphologies)
		translation = try! values.decodeIfPresent(forKey: .translation)
	}
	
	// MARK: - Computed properties
	
	public var description: String {
		return "\(reference.debugDescription) \(surfaceForm)"
	}
	
	public var id: Int {
		return index
	}
	
	public var isPlaceholder: Bool {
		return reference.rawValue == 0
	}
	
	// MARK: - Methods
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		// Required properties
		try! container.encode(index, forKey: .index)
		try! container.encode(reference, forKey: .reference)
		try! container.encode(surfaceForm, forKey: .surfaceForm)
		// Optional properties
		try! container.encodeIfPresent(relatedReference, forKey: .relatedReference)
		try! container.encodeIfPresent(lexicalID, forKey: .lexicalID)
		try! container.encodeIfPresent(morphologies?.nonEmpty, forKey: .morphologies)
		try! container.encodeIfPresent(translation, forKey: .translation)
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(index)
	}
	
	public func describeMorphology(using format: MorphologyDescriptionFormat) -> String? {
		guard let morphologies else {
			return nil
		}
		let formattedMorphologies = morphologies.compactMap { $0.describe(using: format) }
		return formattedMorphologies.joined(separator: "; ")
	}
	
	// MARK: - Custom operators
	
	public static func == (lhs: Token, rhs: Token) -> Bool {
		lhs.index == rhs.index
	}
	
	// MARK: - Nested types
	
	public enum CodingKeys: String, CodingKey, CaseIterable {
		case index
		case reference
		case altReference
		case relatedReference
		case lexicalID
		case surfaceForm
		case morphologies
		case translation
		
		public var stringValue: String {
			return rawValue
		}
	}
}
