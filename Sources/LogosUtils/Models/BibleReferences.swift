//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation
import GRDB
/// The number of bits used to represent each slot.
fileprivate let bookSlot = 3
fileprivate let chapterSlot = 2
fileprivate let verseSlot = 1
fileprivate let tokenSlot = 0

/// The radix value for each slot.
fileprivate let bookRadix = 1 << (8 * bookSlot)
fileprivate let chapterRadix = 1 << (8 * chapterSlot)
fileprivate let verseRadix = 1 << (8 * verseSlot)
fileprivate let tokenRadix = 1 << (8 * tokenSlot)

/// The maximum value that can be represented in each slot.
fileprivate let bookBits = bookRadix * 0xFF
fileprivate let chapterBits = chapterRadix * 0xFF
fileprivate let verseBits = verseRadix * 0xFF
fileprivate let tokenBits = tokenRadix * 0xFF

/// The maximum value that can be represented in the id bits for each slot.
fileprivate let bookIdBits = bookBits
fileprivate let chapterIdBits = bookBits + chapterBits
fileprivate let verseIdBits = bookBits + chapterBits + verseBits
fileprivate let tokenIdBits = bookBits + chapterBits + verseBits + tokenBits

/// The bits that need to be flipped to obtain reverse id bits for each slot.
fileprivate let reverseBookIdBits = bookBits ^ tokenIdBits
fileprivate let reverseChapterIdBits = chapterBits ^ tokenIdBits
fileprivate let reverseVerseIdBits = verseBits ^ tokenIdBits
fileprivate let reverseTokenIdBits = tokenBits ^ tokenIdBits

/// The names of the properties in the container.
fileprivate var propertyNames = ["book", "chapter", "verse", "token"]

/// Enum representing the offset between two Bible references.
public enum ReferenceOffset {
	case differentBook
	case differentChapter
	case differentVerse
	case differentToken
	case differentMorpheme
	case identical
}

/// A protocol representing a container for a Bible reference.
public protocol BibleReferenceContainer: Equatable, Comparable, Codable, Hashable, CustomStringConvertible, CustomDebugStringConvertible, RawRepresentable, DatabaseValueConvertible {
	/// The total number of indices used in the reference container.
	static var totalIndices: Int { get }
	/// The valid bits used for the id in the reference container.
	static var validIdBits: Int { get }
	
	/// The raw value of the reference container.
	var rawValue: Int { get set }
	
	/// Initializes a Bible reference container with the given raw value.
	/// - Parameter rawValue: The raw value of the reference container.
	init(rawValue: Int)
	
	/// The next reference container in sequence.
	var next: Self { get }
}

public extension BibleReferenceContainer {
	/// Initializes a Bible reference container with a raw value of zero.
	init() {
		self.init(rawValue: 0)
	}
	
	// MARK: - Coding
	
	/// Initializes a Bible reference container by decoding from the given decoder.
	/// - Parameter decoder: The decoder to use for decoding the reference container.
	/// - Throws: An error if the decoding process fails.
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(rawValue: try container.decode(Int.self))
	}
	
	/// Encodes the Bible reference container using the given encoder.
	/// - Parameter encoder: The encoder to use for encoding the reference container.
	/// - Throws: An error if the encoding process fails.
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
	
	// MARK: - Collections
	
	/// The raw indices of the reference container.
	var rawIndices: [UInt8] {
		return Array(rawValue.bytes.prefix(4).reversed().prefix(Self.totalIndices))
	}
	
	/// The indices of the reference container.
	var indices: [Int] {
		return rawIndices.map { return Int($0) }
	}
	
	// MARK: - Equatable and Comparable
	
	static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
	
	// MARK: - Other
	
	/// Initializes a Bible reference container using a decimal value.
	/// - Parameter decimalValue: The decimal value representing the reference container.
	init(decimalValue: Int) {
		var result = 0
		for index in 0 ..< 4 {
			result += ((decimalValue / pow(1000, index)) % 1000) * (1 << (8 * index))
		}
		self.init(rawValue: result)
	}
	
	/// Hashes the essential components of the reference container by feeding them into the given hasher.
	/// - Parameter hasher: The hasher to use in the hashing process.
	func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
	
	/// A textual representation of the reference container, suitable for debugging.
	var debugDescription: String {
		let mapped = zip(propertyNames, rawIndices).map { $0.0 + ": " + String($0.1) }
		return "(" + mapped.joined(separator: ", ") + ")"
	}
	
	/// A textual representation of the reference container.
	var description: String {
		return "0x" + String(format: "%02X", rawValue)
	}
	
	/// The ID value of the reference container.
	var id: Int {
		return rawValue
	}
	
	/// The decimal value of the reference container.
	var decimalValue: Int {
		let bytes = Array(rawValue.bytes.prefix(4))
		var result = 0
		for index in bytes.indices {
			let multiplicand = Int(bytes[index])
			let multiplier = pow(1000, Int(index))
			result += multiplier * multiplicand
		}
		return result
	}
	
	/// Indicates whether the reference container is valid or not.
	var isValid: Bool {
		guard rawValue == rawValue & Self.validIdBits else {
			return false
		}
		return rawIndices.allSatisfy { $0 > 0 }
	}
	
	/// Calculates the offset between the reference container and another reference container.
	/// - Parameter reference: The reference container to compare against.
	/// - Returns: The offset between the two reference containers.
	func offset(from reference: any BibleReferenceContainer) -> ReferenceOffset {
		let difference = rawValue ^ reference.rawValue
		
		switch difference {
		case bookRadix ..< Int.max:
			return .differentBook
		case chapterRadix ..< bookRadix:
			return .differentChapter
		case verseRadix ..< chapterRadix:
			return .differentVerse
		case tokenRadix ..< verseRadix:
			return .differentToken
		default:
			return .identical
		}
	}
}

// MARK: - Book

/// A protocol representing a container for a book reference in the Bible.
public protocol BookReferenceContainer: BibleReferenceContainer {
}

public extension BookReferenceContainer {
	
	/// The book index in the reference container.
	var bookIndex: BookIndex {
		get {
			return BookIndex(rawValue: rawValue / bookRadix)
		}
		set {
			rawValue = (rawValue & reverseBookIdBits) + (newValue.rawValue * bookRadix)
		}
	}
	
	/// The book reference in the reference container.
	var bookReference: BookReference {
		return BookReference(rawValue: rawValue & bookIdBits)
	}
	
	/// The raw ID value for the book in the reference container.
	var rawBookId: Int {
		return rawValue & bookIdBits
	}
}

/// A struct representing a book reference in the Bible.
public struct BookReference: BookReferenceContainer {
	public static let totalIndices: Int = 1
	public static let validIdBits: Int = bookIdBits
	
	public var rawValue: Int
	
	/// Initializes a book reference with the given raw value.
	/// - Parameter rawValue: The raw value of the book reference.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a book reference with the given book index.
	/// - Parameter book: The book index.
	public init(book: BookIndex) {
		self.init(rawValue: book.rawValue * bookRadix)
	}
	
	/// The next book reference in sequence.
	public var next: BookReference {
		return BookReference(book: bookIndex + 1)
	}
}

// MARK: - Chapter

/// A protocol representing a container for a chapter reference in the Bible.
public protocol ChapterReferenceContainer: BookReferenceContainer {
}

public extension ChapterReferenceContainer {
	/// The chapter index in the reference container.
	var chapterIndex: ChapterIndex {
		get {
			return ChapterIndex(rawValue: (rawValue & chapterBits) / chapterRadix)
		}
		set {
			rawValue = (rawValue & reverseChapterIdBits) + (newValue.rawValue * chapterRadix)
		}
	}
	
	/// The chapter reference in the reference container.
	var chapterReference: ChapterReference {
		return ChapterReference(rawValue: rawValue & chapterIdBits)
	}
	
	/// The raw ID value for the chapter in the reference container.
	var rawChapterId: Int {
		return rawValue & chapterIdBits
	}
}

/// A struct representing a chapter reference in the Bible.
public struct ChapterReference: ChapterReferenceContainer {
	public static let totalIndices: Int = 2
	public static let validIdBits: Int = chapterIdBits
	
	public var rawValue: Int
	
	/// Initializes a chapter reference with the given raw value.
	/// - Parameter rawValue: The raw value of the chapter reference.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a chapter reference with the given book index and chapter index.
	/// - Parameters:
	///   - book: The book index.
	///   - chapter: The chapter index.
	public init(book: BookIndex, chapter: ChapterIndex) {
		self.init(rawValue: book.rawValue * bookRadix
				  + chapter.rawValue * chapterRadix)
	}
	
	/// Initializes a chapter reference with the given book reference and chapter index.
	/// - Parameters:
	///   - bookReference: The book reference.
	///   - chapter: The chapter index.
	public init(bookReference: BookReference, chapter: ChapterIndex) {
		self.init(rawValue: bookReference.rawValue
				  + chapter.rawValue * chapterRadix)
	}
	
	/// The next chapter reference in sequence.
	public var next: ChapterReference {
		return ChapterReference(bookReference: bookReference, chapter: chapterIndex + 1)
	}
}

// MARK: - Verse

/// A protocol representing a container for a verse reference in the Bible.
public protocol VerseReferenceContainer: ChapterReferenceContainer {
}

public extension VerseReferenceContainer {
	/// The verse index in the reference container.
	var verseIndex: VerseIndex {
		get {
			return VerseIndex(rawValue: (rawValue & verseBits) / verseRadix)
		}
		set {
			rawValue = (rawValue & reverseVerseIdBits) + (newValue.rawValue * verseRadix)
		}
	}
	
	/// The verse reference in the reference container.
	var verseReference: VerseReference {
		return VerseReference(rawValue: rawValue & verseIdBits)
	}
	
	/// The raw ID value for the verse in the reference container.
	var rawVerseId: Int {
		return rawValue & verseIdBits
	}
}

/// A struct representing a verse reference in the Bible.
public struct VerseReference: VerseReferenceContainer {
	public static let totalIndices: Int = 3
	public static let validIdBits: Int = verseIdBits
	
	public var rawValue: Int
	
	/// Initializes a verse reference with the given raw value.
	/// - Parameter rawValue: The raw value of the verse reference.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a verse reference with the given book index, chapter index, and verse index.
	/// - Parameters:
	///   - book: The book index.
	///   - chapter: The chapter index.
	///   - verse: The verse index.
	public init(book: BookIndex, chapter: ChapterIndex, verse: VerseIndex) {
		self.init(rawValue: book.rawValue * bookRadix
				  + chapter.rawValue * chapterRadix
				  + verse.rawValue * verseRadix)
	}
	
	/// Initializes a verse reference with the given book reference, chapter index, and verse index.
	/// - Parameters:
	///   - bookReference: The book reference.
	///   - chapter: The chapter index.
	///   - verse: The verse index.
	public init(bookReference: BookReference, chapter: ChapterIndex, verse: VerseIndex) {
		self.init(rawValue: bookReference.rawValue
				  + chapter.rawValue * chapterRadix
				  + verse.rawValue * verseRadix)
	}
	
	/// Initializes a verse reference with the given chapter reference and verse index.
	/// - Parameters:
	///   - chapterReference: The chapter reference.
	///   - verse: The verse index.
	public init(chapterReference: ChapterReference, verse: VerseIndex) {
		self.init(rawValue: chapterReference.rawValue
				  + verse.rawValue * verseRadix)
	}
	
	/// The next verse reference in sequence.
	public var next: VerseReference {
		return VerseReference(chapterReference: chapterReference, verse: verseIndex + 1)
	}
}

// MARK: - Token

/// A protocol representing a container for a token reference in the Bible.
public protocol TokenReferenceContainer: VerseReferenceContainer {
}

public extension TokenReferenceContainer {
	/// The token index in the reference container.
	var tokenIndex: TokenIndex {
		get {
			return TokenIndex(rawValue: (rawValue & tokenBits) / tokenRadix)
		}
		set {
			rawValue = (rawValue & reverseTokenIdBits) + (newValue.rawValue * tokenRadix)
		}
	}
	
	/// The token reference in the reference container.
	var tokenReference: TokenReference {
		return TokenReference(rawValue: rawValue & verseIdBits)
	}
	
	/// The raw ID value for the token in the reference container.
	var rawTokenId: Int {
		return rawValue & tokenIdBits
	}
}

/// A struct representing a token reference in the Bible.
public struct TokenReference: TokenReferenceContainer {
	public static let totalIndices: Int = 4
	public static let validIdBits: Int = tokenIdBits
	
	public var rawValue: Int
	
	/// Initializes a token reference with the given raw value.
	/// - Parameter rawValue: The raw value of the token reference.
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Initializes a token reference with the given book index, chapter index, verse index, and token index.
	/// - Parameters:
	///   - book: The book index.
	///   - chapter: The chapter index.
	///   - verse: The verse index.
	///   - token: The token index.
	public init(book: BookIndex, chapter: ChapterIndex, verse: VerseIndex, token: TokenIndex) {
		self.init(rawValue: book.rawValue * bookRadix
				  + chapter.rawValue * chapterRadix
				  + verse.rawValue * verseRadix
				  + token.rawValue * tokenRadix)
	}
	
	/// Initializes a token reference with the given book reference, chapter index, verse index, and token index.
	/// - Parameters:
	///   - bookReference: The book reference.
	///   - chapter: The chapter index.
	///   - verse: The verse index.
	///   - token: The token index.
	public init(bookReference: BookReference, chapter: ChapterIndex, verse: VerseIndex, token: TokenIndex) {
		self.init(rawValue: bookReference.rawValue
				  + chapter.rawValue * chapterRadix
				  + verse.rawValue * verseRadix
				  + token.rawValue * tokenRadix)
	}
	
	/// Initializes a token reference with the given chapter reference, verse index, and token index.
	/// - Parameters:
	///   - chapterReference: The chapter reference.
	///   - verse: The verse index.
	///   - token: The token index.
	public init(chapterReference: ChapterReference, verse: VerseIndex, token: TokenIndex) {
		self.init(rawValue: chapterReference.rawValue
				  + verse.rawValue * verseRadix
				  + token.rawValue * tokenRadix)
	}
	
	/// Initializes a token reference with the given verse reference and token index.
	/// - Parameters:
	///   - verseReference: The verse reference.
	///   - token: The token index.
	public init(verseReference: VerseReference, token: TokenIndex) {
		self.init(rawValue: verseReference.rawValue
				  + token.rawValue * tokenRadix)
	}
	
	/// The next token reference in sequence.
	public var next: TokenReference {
		return TokenReference(verseReference: verseReference, token: tokenIndex + 1)
	}
}
