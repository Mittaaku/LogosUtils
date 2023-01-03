//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

fileprivate let bookRadix				= tokenRadix << 24
fileprivate let chapterRadix			= tokenRadix << 16
fileprivate let verseRadix				= tokenRadix << 8
fileprivate let tokenRadix				= 0x01

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

@available(iOS 13.0, macOS 10.15, *)
public protocol BibleReferenceContainer: Equatable, Comparable, Codable, Hashable, Identifiable, CustomStringConvertible, RawRepresentable {
	var totalIndices: Int { get }
	
	var rawValue: Int { get set }
	
	init(rawValue: Int)
}

@available(iOS 13.0, macOS 10.15, *)
public extension BibleReferenceContainer {
	
	// MARK: Coding
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(rawValue: try container.decode(Int.self))
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
	
	// MARK: Collections
	
	var uintIndices: [UInt8] {
		let shifted = rawValue >> (8 * abs(totalIndices - 4))
		return Array(shifted.bytes.prefix(totalIndices)).reversed()
	}
	
	var indices: [Int] {
		return uintIndices.map{ return Int($0) }
	}
	
	// MARK: Equatable and Comparable
	
	static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
	
	// MARK: Other
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
	
	var description: String {
		return uintIndices.description
	}
	
	var id: Int {
		return rawValue
	}
	
	var isValid: Bool {
		return uintIndices.allSatisfy(\.isPositive)
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
@available(iOS 13.0, macOS 10.15, *)
public protocol BookReferenceContainer: BibleReferenceContainer {
}

@available(iOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, macOS 10.15, *)
public protocol ChapterReferenceContainer: BookReferenceContainer {
}

@available(iOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, macOS 10.15, *)
public protocol VerseReferenceContainer: ChapterReferenceContainer {
}

@available(iOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, macOS 10.15, *)
public protocol TokenReferenceContainer: VerseReferenceContainer {
}

@available(iOS 13.0, macOS 10.15, *)
public extension TokenReferenceContainer {
	
	var tokenId: Int {
		return rawValue & tokenIdBits
	}
	
	var tokenIndex: Int {
		get {
			return (rawValue & tokenBits) / tokenRadix
		}
		set {
			rawValue = (rawValue & reverseTokenIdBits) + (newValue * tokenRadix)
		}
	}
	
	var tokenReference: TokenReference {
		return TokenReference(rawValue: rawValue & verseIdBits)
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct BookReference: BookReferenceContainer {
	
	public let totalIndices: Int = 1
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(bookNumber: Int) {
		self.rawValue = (bookNumber * bookRadix)
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct ChapterReference: ChapterReferenceContainer {
	public let totalIndices: Int = 2
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(bookNumber book: Int, chapterNumber chapter: Int) {
		self.rawValue = (book * bookRadix)
		+ (chapter * chapterRadix)
	}
	
	public init(bookReference: BookReference, chapterNumber chapter: Int) {
		self.rawValue = bookReference.rawValue
		+ (chapter * chapterRadix)
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct VerseReference: VerseReferenceContainer {
	public let totalIndices: Int = 3
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(bookNumber book: Int, chapterNumber chapter: Int, verseNumber verse: Int) {
		self.rawValue = (book * bookRadix)
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
	}
	
	public init(bookReference: BookReference, chapterNumber chapter: Int, verseNumber verse: Int) {
		self.rawValue = bookReference.rawValue
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
	}
	
	public init(chapterReference: ChapterReference, verseNumber verse: Int) {
		self.rawValue = chapterReference.rawValue
		+ (verse * chapterRadix)
	}
}

@available(iOS 13.0, macOS 10.15, *)
public struct TokenReference: TokenReferenceContainer {
	public let totalIndices: Int = 4
	
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(bookNumber book: Int, chapterNumber chapter: Int, verseNumber verse: Int, tokenIndex token: Int) {
		self.rawValue = (book * bookRadix)
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
		+ (token * tokenRadix)
	}
	
	public init(bookReference: BookReference, chapterNumber chapter: Int, verseNumber verse: Int, tokenIndex token: Int) {
		self.rawValue = bookReference.rawValue
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
		+ (token * tokenRadix)
	}
	
	public init(chapterReference: ChapterReference, verseNumber verse: Int, tokenIndex token: Int) {
		self.rawValue = chapterReference.rawValue
		+ (verse * verseRadix)
		+ (token * tokenRadix)
	}
	
	public init(verseReference: VerseReference, tokenIndex token: Int) {
		self.rawValue = verseReference.rawValue
		+ (token * tokenRadix)
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
