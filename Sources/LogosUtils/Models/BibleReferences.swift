//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

fileprivate let bookSlot				= 3
fileprivate let chapterSlot				= 2
fileprivate let verseSlot				= 1
fileprivate let tokenSlot				= 0

fileprivate let bookRadix				= 1 << (8 * bookSlot)
fileprivate let chapterRadix			= 1 << (8 * chapterSlot)
fileprivate let verseRadix				= 1 << (8 * verseSlot)
fileprivate let tokenRadix				= 1 << (8 * tokenSlot)

fileprivate let bookBits				= bookRadix * 0xFF
fileprivate let chapterBits				= chapterRadix * 0xFF
fileprivate let verseBits				= verseRadix * 0xFF
fileprivate let tokenBits				= tokenRadix * 0xFF

fileprivate let bookIdBits				= bookBits
fileprivate let chapterIdBits			= bookBits + chapterBits
fileprivate let verseIdBits				= bookBits + chapterBits + verseBits
fileprivate let tokenIdBits				= bookBits + chapterBits + verseBits + tokenBits

fileprivate let reverseBookIdBits		= bookBits ^ tokenIdBits
fileprivate let reverseChapterIdBits	= chapterBits ^ tokenIdBits
fileprivate let reverseVerseIdBits		= verseBits ^ tokenIdBits
fileprivate let reverseTokenIdBits		= tokenBits ^ tokenIdBits

fileprivate var propertyNames = ["book", "chapter", "verse", "token"]

@available(iOS 15.4, macOS 12.3, *)
public protocol BibleReferenceContainer: Equatable, Comparable, Codable, Hashable, Identifiable, CustomStringConvertible, CustomDebugStringConvertible, RawRepresentable, CodingKeyRepresentable {
	static var totalIndices: Int { get }
	static var validIdBits: Int { get }
	
	var rawValue: Int { get set }
	
	init(rawValue: Int)
}

@available(iOS 15.4, macOS 12.3, *)
public extension BibleReferenceContainer {
	
	// MARK: Coding
	
	init?<T: CodingKey>(codingKey: T) {
		if let intValue = codingKey.intValue {
			self.init(decimalValue: intValue)
		} else {
			return nil
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(decimalValue: try container.decode(Int.self))
	}
	
	var codingKey: CodingKey {
		return IntegerCodingKey(rawValue: decimalValue)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(decimalValue)
	}
	
	// MARK: Collections
	
	var rawIndices: [UInt8] {
		return Array(rawValue.bytes.prefix(4).reversed().prefix(Self.totalIndices))
	}
	
	var indices: [Int] {
		return rawIndices.map { return Int($0) }
	}
	
	// MARK: Equatable and Comparable
	
	static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
	
	// MARK: Other
	
	init(decimalValue: Int) {
		var result = 0
		for index in 0 ..< 4 {
			result += ((decimalValue / 1000.pow(to: index)) % 1000) * (1 << (8 * index))
		}
		self.init(rawValue: result)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
	
	var debugDescription: String {
		let mapped = zip(propertyNames, rawIndices).map { $0.0 + ": " + String($0.1) }
		return "(" + mapped.joined(separator: ", ") + ")"
	}
	
	var description: String {
		return "0x" + String(format:"%02X", rawValue)
	}
	
	var id: Int {
		return rawValue
	}
	
	var decimalValue: Int {
		let bytes = Array(rawValue.bytes.prefix(4))
		var result = 0
		for index in bytes.indices {
			let multiplicand = Int(bytes[index])
			let multiplier = 1000.pow(to: Int(index))
			result += multiplier * multiplicand
		}
		return result
	}
	
	var isValid: Bool {
		guard rawValue == rawValue & Self.validIdBits else {
			return false
		}
		return rawIndices.allSatisfy(\.isPositive)
	}
	
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

@available(iOS 15.4, macOS 12.3, *)
public protocol BookReferenceContainer: BibleReferenceContainer {
}

@available(iOS 15.4, macOS 12.3, *)
public extension BookReferenceContainer {
	
	var bookId: Int {
		return rawValue & bookIdBits
	}
	
	var bookNumber: BookNumber {
		get {
			return BookNumber(rawValue: rawValue / bookRadix)
		}
		set {
			rawValue = (rawValue & reverseBookIdBits) + (newValue.rawValue * bookRadix)
		}
	}
	
	var bookReference: BookReference {
		return BookReference(rawValue: rawValue & bookIdBits)
	}
	
	var bookName: BookName {
		guard let result = BookName(rawValue: rawValue / bookRadix) else {
			fatalError("Book index out of bounds")
		}
		return result
	}
}

@available(iOS 15.4, macOS 12.3, *)
public protocol ChapterReferenceContainer: BookReferenceContainer {
}

@available(iOS 15.4, macOS 12.3, *)
public extension ChapterReferenceContainer {
	
	var chapterId: Int {
		return rawValue & chapterIdBits
	}
	
	var chapterNumber: ChapterNumber {
		get {
			return ChapterNumber(rawValue: (rawValue & chapterBits) / chapterRadix)
		}
		set {
			rawValue = (rawValue & reverseChapterIdBits) + (newValue.rawValue * chapterRadix)
		}
	}
	
	var chapterReference: ChapterReference {
		return ChapterReference(rawValue: rawValue & chapterIdBits)
	}
}

@available(iOS 15.4, macOS 12.3, *)
public protocol VerseReferenceContainer: ChapterReferenceContainer {
}

@available(iOS 15.4, macOS 12.3, *)
public extension VerseReferenceContainer {
	
	var verseId: Int {
		return rawValue & verseIdBits
	}
	
	var verseNumber: VerseNumber {
		get {
			return VerseNumber(rawValue: (rawValue & verseBits) / verseRadix)
		}
		set {
			rawValue = (rawValue & reverseVerseIdBits) + (newValue.rawValue * verseRadix)
		}
	}
	
	var verseReference: VerseReference {
		return VerseReference(rawValue: rawValue & verseIdBits)
	}
}

@available(iOS 15.4, macOS 12.3, *)
public protocol TokenReferenceContainer: VerseReferenceContainer {
}

@available(iOS 15.4, macOS 12.3, *)
public extension TokenReferenceContainer {
	
	var tokenId: Int {
		return rawValue & tokenIdBits
	}
	
	var tokenNumber: TokenNumber {
		get {
			return TokenNumber(rawValue: (rawValue & tokenBits) / tokenRadix)
		}
		set {
			rawValue = (rawValue & reverseTokenIdBits) + (newValue.rawValue * tokenRadix)
		}
	}
	
	var tokenReference: TokenReference {
		return TokenReference(rawValue: rawValue & verseIdBits)
	}
}

@available(iOS 15.4, macOS 12.3, *)
public struct BookReference: BookReferenceContainer {
	public static let totalIndices: Int = 1
	public static let validIdBits: Int = bookIdBits
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(book: Int) {
		self.init(rawValue: book * bookRadix)
	}
}

@available(iOS 15.4, macOS 12.3, *)
public struct ChapterReference: ChapterReferenceContainer {
	public static let totalIndices: Int = 2
	public static let validIdBits: Int = chapterIdBits
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(book: Int, chapter: Int) {
		self.init(rawValue: book * bookRadix
				  + chapter * chapterRadix)
	}
	
	public init(bookReference: BookReference, chapter: Int) {
		self.init(rawValue: bookReference.rawValue
				  + chapter * chapterRadix)
	}
}

@available(iOS 15.4, macOS 12.3, *)
public struct VerseReference: VerseReferenceContainer {
	public static let totalIndices: Int = 3
	public static let validIdBits: Int = verseIdBits
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(book: Int, chapter: Int, verse: Int) {
		self.init(rawValue: book * bookRadix
				  + chapter * chapterRadix
				  + verse * verseRadix)
	}
	
	public init(bookReference: BookReference, chapter: Int, verse: Int) {
		self.init(rawValue: bookReference.rawValue
				  + chapter * chapterRadix
				  + verse * verseRadix)
	}
	
	public init(chapterReference: ChapterReference, verse: Int) {
		self.init(rawValue: chapterReference.rawValue
				  + verse * chapterRadix)
	}
}

@available(iOS 15.4, macOS 12.3, *)
public struct TokenReference: TokenReferenceContainer {
	public static let totalIndices: Int = 4
	public static let validIdBits: Int = tokenIdBits
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(book: Int, chapter: Int, verse: Int, token: Int) {
		self.init(rawValue: book * bookRadix
				  + chapter * chapterRadix
				  + verse * verseRadix
				  + token * tokenRadix)
	}
	
	public init(bookReference: BookReference, chapter: Int, verse: Int, token: Int) {
		self.init(rawValue: bookReference.rawValue
				  + chapter * chapterRadix
				  + verse * verseRadix
				  + token * tokenRadix)
	}
	
	public init(chapterReference: ChapterReference, verse: Int, token: Int) {
		self.init(rawValue: chapterReference.rawValue
				  + verse * verseRadix
				  + token * tokenRadix)
	}
	
	public init(verseReference: VerseReference, token: Int) {
		self.init(rawValue: verseReference.rawValue
				  + token * tokenRadix)
	}
}

public enum ReferenceOffset {
	case differentBook
	case differentChapter
	case differentVerse
	case differentToken
	case differentMorpheme
	case identical
}
