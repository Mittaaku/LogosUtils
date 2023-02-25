//
//  Morphology.swift
//  Created by Tom-Roger Mittag on 24/02/2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
public let grammemeSplitter = try! Regex(#";"#)

@available(iOS 16.0, macOS 13.0, *)
public struct Morphology: LosslessStringConvertible, RawRepresentable, Equatable, Codable {
	public typealias RawValue = String
	
	public var etymology: Etymology? = nil
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
		guard rawGrammemes.count == 13 else {
			preconditionFailure("Invalid grammeme count in string '\(description)'")
		}
		var iterator = rawGrammemes.makeIterator()
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
}

// MARK: Properties
@available(iOS 16.0, macOS 13.0, *)
public extension Morphology {
	
	var gender: Gender? {
		get {
			return genders?.first
		}
		set {
			genders = .init(newValue)
		}
	}
	
	var grammemes: [(any GrammemeType)?] {
		return [etymology, wordClass, verbForm, tense, grammaticalCase, genders, voice, person, number, declension, nounType, degree, punctuation]
	}
	
	var compactAbbreviation: String {
		let strings = grammemes.compactMap { return $0?.description }
		return strings.joined(separator: ", ")
	}
	
	var rawAbbreviation: String {
		let strings = grammemes.map { return $0?.description ?? "" }
		return strings.joined(separator: ";")
	}
	
	var description: String {
		return rawAbbreviation
	}
	
	var rawValue: String {
		return rawAbbreviation
	}
	
	var fullName: String {
		var strings = [String]()
		if nounType?.isProperNoun == true {
			strings.append("Proper")
		}
		strings += grammemes.compactMap { return $0?.fullName }
		return strings.joined(separator: ", ")
	}
}

// MARK: Methods
@available(iOS 16.0, macOS 13.0, *)
public extension Morphology {
}
