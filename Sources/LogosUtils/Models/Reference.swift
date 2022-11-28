//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public struct Reference: Codable, Hashable, Identifiable, CustomStringConvertible {
	public var id: Int
	
	// MARK: General initilizers
	
	public init(book: Int, chapter: Int = 0, verse: Int = 0, word: Int = 0, morpheme: Int = 0) {
		self.id = (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
		+ (word * Reference.wordRadix)
		+ (morpheme * Reference.morphemeRadix)
	}
	
	public init(id: Int) {
		self.id = id
	}
	
	// MARK: Codable
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(id: try container.decode(Int.self))
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(id)
	}
	
	// MARK: Hashable
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	// MARK: Identifiable and other IDs
	
	public var bookId: Int {
		return id & Reference.bookIdBits
	}
	
	public var chapterId: Int {
		return id & Reference.chapterIdBits
	}
	
	public var verseId: Int {
		return id & Reference.verseIdBits
	}
	
	public var wordId: Int {
		return id & Reference.wordIdBits
	}
	
	// MARK: Numbers
	
	public var bookNumber: Int {
		get {
			return id / Reference.bookRadix
		}
		set {
			id = (id & Reference.reverseBookIdBits) + (newValue * Reference.bookRadix)
		}
	}
	
	public var chapterNumber: Int {
		get {
			return (id & Reference.chapterBits) / Reference.chapterRadix
		}
		set {
			id = (id & Reference.reverseChapterIdBits) + (newValue * Reference.chapterRadix)
		}
	}
	
	public var verseNumber: Int {
		get {
			return (id & Reference.verseBits) / Reference.verseRadix
		}
		set {
			id = (id & Reference.reverseVerseIdBits) + (newValue * Reference.verseRadix)
		}
	}
	
	public var wordNumber: Int {
		get {
			return (id & Reference.wordBits) / Reference.wordRadix
		}
		set {
			id = (id & Reference.reverseWordIdBits) + (newValue * Reference.wordRadix)
		}
	}
	
	public var morphemeNumber: Int {
		get {
			return (id & Reference.morphemeBits) / Reference.morphemeRadix
		}
		set {
			id = (id & Reference.reverseMorphemeIdBits) + newValue
		}
	}
	
	// MARK: Conversion
	
	public var bookReference: Reference {
		return Reference(id: id & Reference.bookIdBits)
	}
	
	public var chapterReference: Reference {
		return Reference(id: id & Reference.chapterIdBits)
	}
	
	public var verseReference: Reference {
		return Reference(id: id & Reference.wordIdBits)
	}
	
	public var wordReference: Reference {
		return Reference(id: id & Reference.wordIdBits)
	}
	
	// MARK: CustomStringConvertable
	
	public var description: String {
		return uintArray.description
	}
	
	// MARK: Other
	
	public var uintArray: [UInt8] {
		return Array(id.bytes.prefix(5)).reversed()
	}
	
	public var bookName: BookName? {
		return BookName(rawValue: bookNumber)
	}
	
	public func offset(from reference: Reference) -> Offset {
		let difference = id ^ reference.id
		
		switch difference {
		case Reference.bookRadix ..< Int.max:
			return .differentBook
		case Reference.chapterRadix ..< Reference.bookRadix:
			return .differentChapter
		case Reference.verseRadix ..< Reference.chapterRadix:
			return .differentVerse
		case Reference.wordRadix ..< Reference.verseRadix:
			return .differentWord
		case Reference.morphemeRadix ..< Reference.wordRadix:
			return .differentMorpheme
		default:
			return .identical
		}
	}
}

public extension Reference {
	static let invalid	= Reference(id: 0)
	
	static let bookRadix				= 0x0100000000
	static let chapterRadix				= 0x0001000000
	static let verseRadix				= 0x0000010000
	static let wordRadix				= 0x0000000100
	static let morphemeRadix			= 0x0000000001
	
	static let bookBits					= bookRadix * 0xFF
	static let chapterBits				= chapterRadix * 0xFF
	static let verseBits				= verseRadix * 0xFF
	static let wordBits					= wordRadix * 0xFF
	static let morphemeBits				= morphemeRadix * 0xFF
	
	static let bookIdBits				= bookBits
	static let chapterIdBits			= bookBits + chapterBits
	static let verseIdBits				= bookBits + chapterBits + verseBits
	static let wordIdBits				= bookBits + chapterBits + verseBits + wordBits
	static let morphemeIdBits			= bookBits + chapterBits + verseBits + wordBits + morphemeBits
	
	static let reverseBookIdBits		= bookBits ^ morphemeIdBits
	static let reverseChapterIdBits		= chapterBits ^ morphemeIdBits
	static let reverseVerseIdBits		= verseBits ^ morphemeIdBits
	static let reverseWordIdBits		= wordBits ^ morphemeIdBits
	static let reverseMorphemeIdBits	= morphemeBits ^ morphemeIdBits
	
	enum Offset {
		case differentBook
		case differentChapter
		case differentVerse
		case differentWord
		case differentMorpheme
		case identical
	}
	
	enum BookName: Int {
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
}
