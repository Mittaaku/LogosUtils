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

@available(macOS 10.15, *)
public protocol ReferenceContainer: Equatable, Comparable, Codable, Hashable, Identifiable, CustomStringConvertible {
	var totalIndices: Int { get }
	
	var id: Int { get set }
	
	init(id: Int)
}

@available(macOS 10.15, *)
public extension ReferenceContainer {
	
	// MARK: Coding
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(id: try container.decode(Int.self))
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(id)
	}
	
	// MARK: Hashable
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	// MARK: Collections
	
	var uintIndices: [UInt8] {
		let shifted = id >> (8 * abs(totalIndices - 4))
		return Array(shifted.bytes.prefix(totalIndices)).reversed()
	}
	
	var indices: [Int] {
		return uintIndices.map{ return Int($0) }
	}
	
	// MARK: Equatable and Comparable
	
	static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.id < rhs.id
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.id == rhs.id
	}
	
	// MARK: Other
	
	var description: String {
		return uintIndices.description
	}
	
	func offset(from reference: any ReferenceContainer) -> ReferenceOffset {
		let difference = id ^ reference.id
		
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

@available(macOS 10.15, *)
public protocol BookReferenceContainer: ReferenceContainer {
}

@available(macOS 10.15, *)
public extension BookReferenceContainer {
	
	var bookId: Int {
		return id & bookIdBits
	}
	
	var bookNumber: Int {
		get {
			return id / bookRadix
		}
		set {
			id = (id & reverseBookIdBits) + (newValue * bookRadix)
		}
	}
	
	var bookName: BookName? {
		return BookName(rawValue: bookNumber)
	}
}

@available(macOS 10.15, *)
public protocol ChapterReferenceContainer: BookReferenceContainer {
}

@available(macOS 10.15, *)
public extension ChapterReferenceContainer {
	
	var chapterId: Int {
		return id & chapterIdBits
	}
	
	var chapterNumber: Int {
		get {
			return (id & chapterBits) / chapterRadix
		}
		set {
			id = (id & reverseChapterIdBits) + (newValue * chapterRadix)
		}
	}
	
	var bookReference: Self {
		return Self(id: id & bookIdBits)
	}
}

@available(macOS 10.15, *)
public protocol VerseReferenceContainer: ChapterReferenceContainer {
}

@available(macOS 10.15, *)
public extension VerseReferenceContainer {
	
	var verseId: Int {
		return id & verseIdBits
	}
	
	var verseNumber: Int {
		get {
			return (id & verseBits) / verseRadix
		}
		set {
			id = (id & reverseVerseIdBits) + (newValue * verseRadix)
		}
	}
	
	var chapterReference: Self {
		return Self(id: id & chapterIdBits)
	}
}

@available(macOS 10.15, *)
public protocol TokenReferenceContainer: VerseReferenceContainer {
}

@available(macOS 10.15, *)
public extension TokenReferenceContainer {
	
	var tokenId: Int {
		return id & tokenIdBits
	}
	
	var tokenNumber: Int {
		get {
			return (id & tokenBits) / tokenRadix
		}
		set {
			id = (id & reverseTokenIdBits) + (newValue * tokenRadix)
		}
	}
	
	var verseReference: Self {
		return Self(id: id & verseIdBits)
	}
}

@available(macOS 10.15, *)
public struct BookReference: BookReferenceContainer {
	
	public let totalIndices: Int = 1
	
	public var id: Int
	
	public init(id: Int) {
		self.id = id
	}
	
	public init(bookNumber: Int) {
		self.id = (bookNumber * bookRadix)
	}
}

@available(macOS 10.15, *)
public struct ChapterReference: ChapterReferenceContainer {
	public let totalIndices: Int = 2
	
	public var id: Int
	
	public init(id: Int) {
		self.id = id
	}
	
	public init(bookNumber book: Int, chapter: Int) {
		self.id = (book * bookRadix)
		+ (chapter * chapterRadix)
	}
	
	public init(bookReference: BookReference, chapterNumber chapter: Int) {
		self.id = bookReference.id
		+ (chapter * chapterRadix)
	}
}

@available(macOS 10.15, *)
public struct VerseReference: VerseReferenceContainer {
	public let totalIndices: Int = 3
	
	public var id: Int
	
	public init(id: Int) {
		self.id = id
	}
	
	public init(bookNumber book: Int, chapter: Int, verse: Int) {
		self.id = (book * bookRadix)
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
	}
	
	public init(bookReference: BookReference, chapterNumber chapter: Int, verse: Int) {
		self.id = bookReference.id
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
	}
	
	public init(chapterReference: ChapterReference, verse: Int) {
		self.id = chapterReference.id
		+ (verse * chapterRadix)
	}
}

@available(macOS 10.15, *)
public struct TokenReference: TokenReferenceContainer {
	public let totalIndices: Int = 4
	
	public var id: Int
	
	public init(id: Int) {
		self.id = id
	}
	
	public init(bookNumber book: Int, chapter: Int, verse: Int, token: Int) {
		self.id = (book * bookRadix)
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
		+ (token * tokenRadix)
	}
	
	public init(bookReference: BookReference, chapterNumber chapter: Int, verse: Int, token: Int) {
		self.id = bookReference.id
		+ (chapter * chapterRadix)
		+ (verse * verseRadix)
		+ (token * tokenRadix)
	}
	
	public init(chapterReference: ChapterReference, verse: Int, token: Int) {
		self.id = chapterReference.id
		+ (verse * verseRadix)
		+ (token * tokenRadix)
	}
	
	public init(verseReference: VerseReference, token: Int) {
		self.id = verseReference.id
		+ (token * tokenRadix)
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

public enum ReferenceOffset {
	case differentBook
	case differentChapter
	case differentVerse
	case differentToken
	case differentMorpheme
	case identical
}
