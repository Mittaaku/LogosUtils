//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
struct Token: Codable, Hashable, Identifiable, Equatable, CustomStringConvertible {
	private(set) var index: Int
	private(set) var reference: TokenReference
	var altReference: TokenReference? = nil
	var relatedReference: TokenReference? = nil
	var surfaceForm: String = ""
	var lexicalID: String? = nil
	var morphologies: [Morphology] = []
	var translation: String? = nil
	var extraProperties: [String: String] = [:]
	
	init(index: Int, reference: TokenReference) {
		self.index = index
		self.reference = reference
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		// Required properties
		index = try! values.decode(forKey: .index)
		reference = try! values.decode(forKey: .reference)
		surfaceForm = try! values.decode(forKey: .surfaceForm)
		// Optional properties
		altReference = try! values.decodeIfPresent(forKey: .altReference)
		relatedReference = try! values.decodeIfPresent(forKey: .relatedReference)
		lexicalID = try! values.decodeIfPresent(forKey: .lexicalID)
		morphologies = try! values.decodeIfPresent(forKey: .morphologies) ?? []
		translation = try! values.decodeIfPresent(forKey: .translation)
		extraProperties = try! values.decodeIfPresent(forKey: .extraProperties) ?? [:]
	}
}

// MARK: - Computed Properties
@available(iOS 16.0, macOS 13.0, *)
extension Token {
	var description: String {
		return "\(reference.debugDescription) \(surfaceForm)"
	}
	
	var id: Int {
		return index
	}
}

// MARK: - Methods
@available(iOS 16.0, macOS 13.0, *)
extension Token {
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		// Required properties
		try! container.encode(index, forKey: .index)
		try! container.encode(reference, forKey: .reference)
		try! container.encode(surfaceForm, forKey: .surfaceForm)
		// Optional properties
		try! container.encodeIfPresent(altReference, forKey: .altReference)
		try! container.encodeIfPresent(relatedReference, forKey: .relatedReference)
		try! container.encodeIfPresent(lexicalID, forKey: .lexicalID)
		try! container.encodeIfPresent(morphologies.nonEmpty, forKey: .morphologies)
		try! container.encodeIfPresent(translation, forKey: .translation)
		try! container.encodeIfPresent(extraProperties.nonEmpty, forKey: .extraProperties)
	}
}

// MARK: - Functions and static variables
@available(iOS 16.0, macOS 13.0, *)
extension Token {
}

// MARK: - CodingKeys struct
@available(iOS 16.0, macOS 13.0, *)
extension Token {
	
	enum CodingKeys: String, CodingKey, CaseIterable {
		case index
		case reference
		case altReference
		case relatedReference
		case lexicalID
		case surfaceForm
		case morphologies
		case translation
		case extraProperties
		
		var stringValue: String {
			return CodingKeys.stringKeyByCase[self]!
		}
		
		static var stringKeyByCase = makeShortenedKeysByCase()
	}
}
