//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public struct Reference: Codable, Hashable, Identifiable, CustomStringConvertible {
	public var book: Int
	public var chapter: Int
	public var verse: Int
	public var word: Int
	public var morpheme: Int
	
	// MARK: General initilizers
	
	public init(book: Int, chapter: Int, verse: Int, word: Int = 0, morpheme: Int = 0) {
		self.book = book
		self.chapter = chapter
		self.verse = verse
		self.word = word
		self.morpheme = morpheme
	}
	
	public init(id: Int) {
		book = id / Self.bookRadix
		chapter = (id % Self.bookRadix) / Self.chapterRadix
		verse = (id % Self.chapterRadix) / Self.verseRadix
		word = (id % Self.verseRadix) / Self.wordRadix
		morpheme = id % Self.wordRadix
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
	
	public var id: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
		+ (word * Reference.wordRadix)
		+ morpheme
	}
	
	public var bookId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
	}
	
	public var chapterId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
	}
	
	public var verseId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
	}
	
	public var wordId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
		+ (word * Reference.wordRadix)
	}
	
	// MARK: CustomStringConvertable
	
	public var description: String {
		return String(id)
	}
	
	// MARK: Equating methods
	
	public func sharesBook(with reference: Reference) -> Bool {
		return bookId == reference.bookId
	}
	
	public func sharesChapter(with reference: Reference) -> Bool {
		return chapterId == reference.chapterId
	}
	
	public func sharesVerse(with reference: Reference) -> Bool {
		return verseId == reference.verseId
	}
	
	public func sharesWord(with reference: Reference) -> Bool {
		return wordId == reference.wordId
	}
}

public extension Reference {
	static let invalid      	= Reference(id: 0)
	static let bookRadix    	= 1000000000000
	static let chapterRadix 	= 0001000000000
	static let verseRadix   	= 0000001000000
	static let wordRadix    	= 0000000000100
	static let morphemeRadix    = 0000000000001
}
