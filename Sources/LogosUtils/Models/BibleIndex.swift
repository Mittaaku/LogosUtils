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
	init(_ i: Int) {
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
	
	/// Initializes a book index with the given English name of the book.
	/// - Parameter englishName: The english name of the book.
	public init?(englishName: String) {
		guard let index = BookIndex.indexByEnglishBookName[englishName] else {
			return nil
		}
		self.rawValue = index
	}
	
	static let indexByEnglishBookName = englishBookNamesByIndex.sequentiallyFlipped().duplicatingCaseKeys()
	static let englishBookNamesByIndex = [
		1: ["Genesis", "Gen"],
		2: ["Exodus", "Exo"],
		3: ["Leviticus", "Lev"],
		4: ["Numbers", "Num"],
		5: ["Deuteronomy", "Deut"],
		6: ["Joshua", "Josh"],
		7: ["Judges", "Judg"],
		8: ["Ruth"],
		9: ["1 Samuel", "1st Samuel", "First Samuel", "First Sam", "1 Sam"],
		10: ["2 Samuel", "2nd Samuel", "Second Samuel", "Second Sam", "2 Sam"],
		11: ["1 Kings", "1st Kings", "First Kings", "First Kin", "1 Kin"],
		12: ["2 Kings", "2nd Kings", "Second Kings", "Second Kin", "2 Kin"],
		13: ["1 Chronicles", "1st Chronicles", "First Chronicles", "First Chr", "1 Chr"],
		14: ["2 Chronicles", "2nd Chronicles", "Second Chronicles", "Second Chr", "2 Chr"],
		15: ["Ezra"],
		16: ["Nehemiah", "Neh"],
		17: ["Esther", "Esth"],
		18: ["Job"],
		19: ["Psalms", "Ps"],
		20: ["Proverbs", "Prov"],
		21: ["Ecclesiastes", "Eccles", "Eccl"],
		22: ["Song of Solomon", "Song of Songs", "Canticles", "Song"],
		23: ["Isaiah", "Isa"],
		24: ["Jeremiah", "Jer"],
		25: ["Lamentations", "Lam"],
		26: ["Ezekiel", "Ezek"],
		27: ["Daniel", "Dan"],
		28: ["Hosea", "Hos"],
		29: ["Joel"],
		30: ["Amos"],
		31: ["Obadiah", "Obad"],
		32: ["Jonah", "Jon"],
		33: ["Micah"],
		34: ["Nahum"],
		35: ["Habakkuk", "Hab"],
		36: ["Zephaniah", "Zeph"],
		37: ["Haggai", "Hag"],
		38: ["Zechariah", "Zech"],
		39: ["Malachi", "Mal"],
		40: ["Matthew", "Matt"],
		41: ["Mark"],
		42: ["Luke"],
		43: ["John"],
		44: ["Acts"],
		45: ["Romans", "Rom"],
		46: ["1 Corinthians", "1st Corinthians", "First Corinthians", "First Cor", "1 Cor"],
		47: ["2 Corinthians", "2nd Corinthians", "Second Corinthians", "Second Cor", "2 Cor"],
		48: ["Galatians", "Gal"],
		49: ["Ephesians", "Eph"],
		50: ["Philippians", "Phil"],
		51: ["Colossians", "Col"],
		52: ["1 Thessalonians", "1st Thessalonians", "First Thessalonians", "First Thess", "1 Thess"],
		53: ["2 Thessalonians", "2nd Thessalonians", "Second Thessalonians", "Second Thess", "2 Thess"],
		54: ["1 Timothy", "1st Timothy", "First Timothy", "First Tim", "1 Tim"],
		55: ["2 Timothy", "2nd Timothy", "Second Timothy", "Second Tim", "2 Tim"],
		56: ["Titus"],
		57: ["Philemon", "Philem"],
		58: ["Hebrews", "Heb"],
		59: ["James", "Jas"],
		60: ["1 Peter", "1st Peter", "First Peter", "First Pet", "1 Pet"],
		61: ["2 Peter", "2nd Peter", "Second Peter", "Second Pet", "2 Pet"],
		62: ["1 John", "1st John", "First John", "First Jn", "1 Jn"],
		63: ["2 John", "2nd John", "Second John", "Second Jn", "2 Jn"],
		64: ["3 John", "3rd John", "Third John", "Third Jn", "3 Jn"],
		65: ["Jude"],
		66: ["Revelation", "Rev", "Apocalypse"]
	]
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
