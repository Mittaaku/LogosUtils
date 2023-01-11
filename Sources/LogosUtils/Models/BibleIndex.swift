//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

@available(iOS 15.4, macOS 12.3, *)
public protocol BibleIndex: RawRepresentable, Codable, Hashable, CustomStringConvertible, ExpressibleByIntegerLiteral, AdditiveArithmetic, Identifiable, CodingKeyRepresentable {
	
	var rawValue: Int { get set }
	
	init(rawValue: Int)
}

@available(iOS 15.4, macOS 12.3, *)
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

@available(iOS 15.4, macOS 12.3, *)
public struct BookNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}
	
@available(iOS 15.4, macOS 12.3, *)
extension BookNumber {
	static var genesis = 1
	static var exodus = 2
	static var leviticus = 3
	static var numbers = 4
	static var deuteronomy = 5
	static var joshua = 6
	static var judges = 7
	static var ruth = 8
	static var firstSamuel = 9
	static var secondSamuel = 10
	static var firstKings = 11
	static var secondKings = 12
	static var firstChronicles = 13
	static var secondChronicles = 14
	static var ezra = 15
	static var nehemiah = 16
	static var esther = 17
	static var job = 18
	static var psalms = 19
	static var proverbs = 20
	static var ecclesiastes = 21
	static var songOfSongs = 22
	static var isaiah = 23
	static var jeremiah = 24
	static var lamentations = 25
	static var ezekiel = 26
	static var daniel = 27
	static var hosea = 28
	static var joel = 29
	static var amos = 30
	static var obadiah = 31
	static var jonah = 32
	static var micah = 33
	static var nahum = 34
	static var habakkuk = 35
	static var zephaniah = 36
	static var haggai = 37
	static var zechariah = 38
	static var malachi = 39
	static var matthew = 40
	static var mark = 41
	static var luke = 42
	static var john = 43
	static var actsOfTheApostles = 44
	static var romans = 45
	static var firstCorinthians = 46
	static var secondCorinthians = 47
	static var galatians = 48
	static var ephesians = 49
	static var philippians = 50
	static var colossians = 51
	static var firstThessalonians = 52
	static var secondThessalonians = 53
	static var firstTimothy = 54
	static var secondTimothy = 55
	static var titus = 56
	static var philemon = 57
	static var hebrews = 58
	static var james = 59
	static var firstPeter = 60
	static var secondPeter = 61
	static var firstJohn = 62
	static var secondJohn = 63
	static var thirdJohn = 64
	static var jude = 65
	static var revelation = 66
}

@available(iOS 15.4, macOS 12.3, *)
public struct ChapterNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

@available(iOS 15.4, macOS 12.3, *)
public struct VerseNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}

@available(iOS 15.4, macOS 12.3, *)
public struct TokenNumber: BibleIndex {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init(integerLiteral: Int) {
		self.rawValue = integerLiteral
	}
}
