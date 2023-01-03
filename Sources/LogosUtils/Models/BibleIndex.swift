//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 02/01/2023.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
public protocol BibleIndex: RawRepresentable, Codable, Hashable, Identifiable, CustomStringConvertible, ExpressibleByIntegerLiteral, AdditiveArithmetic {
	
	var rawValue: Int { get set }
	
	init(rawValue: Int)
}

@available(iOS 13.0, macOS 10.15, *)
public extension BibleIndex {
	var id: Int {
		return rawValue
	}
	
	var description: String {
		return String(rawValue)
	}
	
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let rawValue = try container.decode(Int.self)
		self.init(rawValue: rawValue)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(rawValue)
	}
	
	static func + (lhs: Self, rhs: Self) -> Self {
		return Self(rawValue: lhs.rawValue + rhs.rawValue)
	}
	
	static func - (lhs: Self, rhs: Self) -> Self {
		return Self(rawValue: lhs.rawValue - rhs.rawValue)
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct BookNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
	
	public var name: BookName {
		guard let result = BookName(rawValue: rawValue) else {
			fatalError("Book index out of bounds")
		}
		return result
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct ChapterNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct VerseNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

public enum BookName: Int {
	case genesis = 1
	case exodus
	case leviticus
	case numbers
	case deuteronomy
	case joshua
	case judges
	case ruth
	case firstSamuel
	case secondSamuel
	case firstKings
	case secondKings
	case firstChronicles
	case secondChronicles
	case ezra
	case nehemiah
	case esther
	case job
	case psalms
	case proverbs
	case ecclesiastes
	case songOfSongs
	case isaiah
	case jeremiah
	case lamentations
	case ezekiel
	case daniel
	case hosea
	case joel
	case amos
	case obadiah
	case jonah
	case micah
	case nahum
	case habakkuk
	case zephaniah
	case haggai
	case zechariah
	case malachi
	case matthew
	case mark
	case luke
	case john
	case actsOfTheApostles
	case romans
	case firstCorinthians
	case secondCorinthians
	case galatians
	case ephesians
	case philippians
	case colossians
	case firstThessalonians
	case secondThessalonians
	case firstTimothy
	case secondTimothy
	case titus
	case philemon
	case hebrews
	case james
	case firstPeter
	case secondPeter
	case firstJohn
	case secondJohn
	case thirdJohn
	case jude
	case revelation
}
