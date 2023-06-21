//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

/// A protocol representing an index in the Bible.
public protocol BibleIndex: RawRepresentable, Codable, Hashable, CustomStringConvertible, ExpressibleByIntegerLiteral, AdditiveArithmetic {
	
	/// The raw value of the index.
	var rawValue: Int { get set }
	
	/// Initializes a Bible index with the given raw value.
	/// - Parameter rawValue: The raw value of the index.
	init(rawValue: Int)
}

public extension BibleIndex {
	/// Initializes a Bible index by decoding from the given decoder.
	/// - Parameter decoder: The decoder to use for decoding the index.
	/// - Throws: An error if the decoding process fails.
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(Int.self)
		self.init(rawValue: rawValue)
	}
	
	/// Initializes a Bible index with the given interger.
	/// - Parameter i: The interger of the index.
	init(_ i: Int) throws {
		self.init(rawValue: i)
	}
	
	/// Encodes the Bible index using the given encoder.
	/// - Parameter encoder: The encoder to use for encoding the index.
	/// - Throws: An error if the encoding process fails.
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
	
	/// The ID of the Bible index.
	var id: Int {
		return rawValue
	}
	
	/// A textual representation of the Bible index.
	var description: String {
		return String(rawValue)
	}
	
	/// Adds two Bible indexes and returns their sum.
	/// - Parameters:
	///   - lhs: The left-hand side Bible index.
	///   - rhs: The right-hand side Bible index.
	/// - Returns: The sum of the two Bible indexes.
	static func + (lhs: Self, rhs: Self) -> Self {
		return Self(rawValue: lhs.rawValue + rhs.rawValue)
	}
	
	/// Subtracts the second Bible index from the first and returns the difference.
	/// - Parameters:
	///   - lhs: The left-hand side Bible index.
	///   - rhs: The right-hand side Bible index.
	/// - Returns: The difference between the two Bible indexes.
	static func - (lhs: Self, rhs: Self) -> Self {
		return Self(rawValue: lhs.rawValue - rhs.rawValue)
	}
}

/// A struct representing an index for a book in the Bible.
public struct BookIndex: BibleIndex {
	/// The raw value of the book index.
	public var rawValue: Int
	
	/// Initializes a book index with the given raw value.
	/// - Parameter rawValue: The raw value of the book index.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a book index using the given integer literal.
	/// - Parameter integerLiteral: The integer literal representing the book index.
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
	
	public static var genesis = 1
	public static var exodus = 2
	public static var leviticus = 3
	public static var numbers = 4
	public static var deuteronomy = 5
	public static var joshua = 6
	public static var judges = 7
	public static var ruth = 8
	public static var firstSamuel = 9
	public static var secondSamuel = 10
	public static var firstKings = 11
	public static var secondKings = 12
	public static var firstChronicles = 13
	public static var secondChronicles = 14
	public static var ezra = 15
	public static var nehemiah = 16
	public static var esther = 17
	public static var job = 18
	public static var psalms = 19
	public static var proverbs = 20
	public static var ecclesiastes = 21
	public static var songOfSongs = 22
	public static var isaiah = 23
	public static var jeremiah = 24
	public static var lamentations = 25
	public static var ezekiel = 26
	public static var daniel = 27
	public static var hosea = 28
	public static var joel = 29
	public static var amos = 30
	public static var obadiah = 31
	public static var jonah = 32
	public static var micah = 33
	public static var nahum = 34
	public static var habakkuk = 35
	public static var zephaniah = 36
	public static var haggai = 37
	public static var zechariah = 38
	public static var malachi = 39
	public static var matthew = 40
	public static var mark = 41
	public static var luke = 42
	public static var john = 43
	public static var actsOfTheApostles = 44
	public static var romans = 45
	public static var firstCorinthians = 46
	public static var secondCorinthians = 47
	public static var galatians = 48
	public static var ephesians = 49
	public static var philippians = 50
	public static var colossians = 51
	public static var firstThessalonians = 52
	public static var secondThessalonians = 53
	public static var firstTimothy = 54
	public static var secondTimothy = 55
	public static var titus = 56
	public static var philemon = 57
	public static var hebrews = 58
	public static var james = 59
	public static var firstPeter = 60
	public static var secondPeter = 61
	public static var firstJohn = 62
	public static var secondJohn = 63
	public static var thirdJohn = 64
	public static var jude = 65
	public static var revelation = 66
}

/// A struct representing an index for a chapter in the Bible.
public struct ChapterIndex: BibleIndex {
	/// The raw value of the chapter index.
	public var rawValue: Int
	
	/// Initializes a chapter index with the given raw value.
	/// - Parameter rawValue: The raw value of the chapter index.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a chapter index using the given integer literal.
	/// - Parameter integerLiteral: The integer literal representing the chapter index.
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

/// A struct representing an index for a verse in the Bible.
public struct VerseIndex: BibleIndex {
	/// The raw value of the verse index.
	public var rawValue: Int
	
	/// Initializes a verse index with the given raw value.
	/// - Parameter rawValue: The raw value of the verse index.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a verse index using the given integer literal.
	/// - Parameter integerLiteral: The integer literal representing the verse index.
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

/// A struct representing an index for a token in the Bible.
public struct TokenIndex: BibleIndex {
	/// The raw value of the token index.
	public var rawValue: Int
	
	/// Initializes a token index with the given raw value.
	/// - Parameter rawValue: The raw value of the token index.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a token index using the given integer literal.
	/// - Parameter integerLiteral: The integer literal representing the token index.
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}
