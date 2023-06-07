//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public protocol BibleIndex: RawRepresentable, Codable, Hashable, CustomStringConvertible, ExpressibleByIntegerLiteral, AdditiveArithmetic {
	
	var rawValue: Int { get set }
	
	init(rawValue: Int)
}

public extension BibleIndex {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(Int.self)
		self.init(rawValue: rawValue)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
	
	var id: Int {
		return rawValue
	}
	
	var description: String {
		return String(rawValue)
	}
	
	static func + (lhs: Self, rhs: Self) -> Self {
		return Self(rawValue: lhs.rawValue + rhs.rawValue)
	}
	
	static func - (lhs: Self, rhs: Self) -> Self {
		return Self(rawValue: lhs.rawValue - rhs.rawValue)
	}
}

public struct BookNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
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

public struct ChapterNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

public struct VerseNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

public struct TokenNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}
