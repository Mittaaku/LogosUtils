//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

extension Reference {
	static let invalid      	= Reference(id: 0)
	static let bookRadix    	= 1000000000000
	static let chapterRadix 	= 0001000000000
	static let verseRadix   	= 0000001000000
	static let wordRadix    	= 0000000000100
	static let morphemeRadix    = 0000000000001
}

struct Reference: Identifiable, CustomStringConvertible {
	var book: Int
	var chapter: Int
	var verse: Int
	var word: Int
	var morpheme: Int
	
	init(book: Int, chapter: Int, verse: Int, word: Int = 0, morpheme: Int = 0) {
		self.book = book
		self.chapter = chapter
		self.verse = verse
		self.word = word
		self.morpheme = morpheme
	}
	
	init(id: Int) {
		book = id / Self.bookRadix
		chapter = (id % Self.bookRadix) / Self.chapterRadix
		verse = (id % Self.chapterRadix) / Self.verseRadix
		word = (id % Self.verseRadix) / Self.wordRadix
		morpheme = id % Self.wordRadix
	}
	
	var description: String {
		return String(id)
	}
	
	var bookId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
	}
	
	var chapterId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
	}
	
	var verseId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
	}
	
	var wordId: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
		+ (word * Reference.wordRadix)
	}
	
	var id: Int {
		return (book * Reference.bookRadix)
		+ (chapter * Reference.chapterRadix)
		+ (verse * Reference.verseRadix)
		+ (word * Reference.wordRadix)
		+ morpheme
	}
	
	func sharesBook(with reference: Reference) -> Bool {
		return bookId == reference.bookId
	}
	
	func sharesChapter(with reference: Reference) -> Bool {
		return chapterId == reference.chapterId
	}
	
	func sharesVerse(with reference: Reference) -> Bool {
		return verseId == reference.verseId
	}
	
	func sharesWord(with reference: Reference) -> Bool {
		return wordId == reference.wordId
	}
}

extension Reference: Codable {
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(id: try container.decode(Int.self))
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(id)
	}
}

extension Reference: Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
