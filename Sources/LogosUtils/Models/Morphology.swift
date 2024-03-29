//
//  Morphology.swift
//  Created by Tom-Roger Mittag on 24/02/2023.
//

import Foundation

public struct Morphology: Equatable, Codable, Hashable, LosslessStringConvertible, RawRepresentable {
	
	// MARK: - Instance properties
	
	public var language: Language? = nil
	public var etymology: Language? = nil
	public var wordClass: WordClass? = nil
	public var verbForm: VerbForm? = nil
	public var tense: Tense? = nil
	public var grammaticalCase: GrammaticalCase? = nil
	public var genders: GrammemeSet<Gender>? = nil
	public var voice: Voice? = nil
	public var person: Person? = nil
	public var number: Number? = nil
	public var declension: Declension? = nil
	public var nounType: NounType? = nil
	public var degree: GrammaticalDegree? = nil
	public var punctuation: Punctuation? = nil
	
	// MARK: - Initilization
	
	public init() {
	}
	
	public init?(rawValue: String) {
		self.init(rawAbbreviation: rawValue)
	}
	
	public init?(_ description: String) {
		self.init(rawAbbreviation: description)
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(String.self)
		self.init(rawAbbreviation: value)
	}
	
	public init(rawAbbreviation: String) {
		let rawGrammemes = rawAbbreviation.split(separator: grammemeSplitter, omittingEmptySubsequences: false).strings
		guard rawGrammemes.count == 14 else {
			preconditionFailure("Invalid grammeme count in string '\(rawAbbreviation)'")
		}
		var iterator = rawGrammemes.makeIterator()
		language = .init(optionalAbbreviation: iterator.next())
		etymology = .init(optionalAbbreviation: iterator.next())
		wordClass = .init(optionalAbbreviation: iterator.next())
		verbForm = .init(optionalAbbreviation: iterator.next())
		tense = .init(optionalAbbreviation: iterator.next())
		grammaticalCase = .init(optionalAbbreviation: iterator.next())
		genders = .init(optionalAbbreviation: iterator.next())
		voice = .init(optionalAbbreviation: iterator.next())
		person = .init(optionalAbbreviation: iterator.next())
		number = .init(optionalAbbreviation: iterator.next())
		declension = .init(optionalAbbreviation: iterator.next())
		nounType = .init(optionalAbbreviation: iterator.next())
		degree = .init(optionalAbbreviation: iterator.next())
		punctuation = .init(optionalAbbreviation: iterator.next())
	}
	
	// MARK: - Computed properties
	
	public var gender: Gender? {
		get {
			guard let genderElements = genders?.elements else {
				return nil
			}
			assert(genderElements.count == 1, "The .gender property shouldn't be accessed when there are more than one gender.")
			return genderElements.first
		}
		set {
			genders = .init(newValue)
		}
	}
	
	public var allGrammemes: [(any GrammemeType)?] {
		return [language, etymology, wordClass, verbForm, tense, grammaticalCase, genders, voice, person, number, declension, nounType, degree, punctuation]
	}
	
	public var description: String {
		return rawAbbreviation
	}
	
	public var describableGrammemes: [(any GrammemeType)] {
		let describable: [(any GrammemeType)?] = [language, wordClass, verbForm, tense, grammaticalCase, genders, voice, person, number, declension, degree]
		return describable.compactMap { $0 }
	}
	
	public var rawAbbreviation: String {
		let strings = allGrammemes.map { return $0?.description ?? "" }
		return strings.joined(separator: ";")
	}
	
	public var rawValue: String {
		return rawAbbreviation
	}
	
	// MARK: - Methods
	
	public func describe(using format: MorphologyDescriptionFormat) -> String {
		var result = ""
		let strings: [String]
		switch format {
		case .abbreviation, .commaDelineatedAbbreviation:
			strings = describableGrammemes.map(\.abbreviation)
		case .fullName, .commaDelineatedFullName:
			if nounType == .proper {
				result.append("Proper ")
			}
			strings = describableGrammemes.map(\.fullName)
		}
		result += strings.joined(separator: format.deliniator)
		return result
	}
	
	// MARK: - Static members
	
	public let grammemeSplitter = NSRegularExpression(#";"#)
}
