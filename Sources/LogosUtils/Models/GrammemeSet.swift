//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

@available(iOS 16.0, macOS 13.0, *)
public let grammemeAbbreviationSeparator = try! Regex(#"\/"#)

@available(iOS 16.0, macOS 13.0, *)
public struct GrammemeSet<Element: GrammemeEnum>: GrammemeType, SetAlgebra, ExpressibleByArrayLiteral {
	
	public var rawValue: Int
	
	public init() {
		rawValue = 0
	}
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public init?(_ element: Element?) {
		guard let element else {
			return nil
		}
		rawValue = 1 << element.rawValue
	}
	
	public init(arrayLiteral: Element...) {
		rawValue = 0
		for element in arrayLiteral {
			rawValue.setBit(at: element.rawValue)
		}
	}
	
	public init?(abbreviation: String) {
		rawValue = 0
		insert(abbreviation: abbreviation)
	}
	
	public init(otherSet: Self?, abbreviation: String) {
		rawValue = otherSet?.rawValue ?? 0
		insert(abbreviation: abbreviation)
	}
}

// MARK: Properties
@available(iOS 16.0, macOS 13.0, *)
public extension GrammemeSet {
	
	var elements: [Element] {
		var result = [Element]()
		let highestBitIndex = Int(flsl(rawValue))
		for i in 0 ..< highestBitIndex {
			guard rawValue.checkBit(at: i) else {
				continue
			}
			guard let element = Element(rawValue: i) else {
				preconditionFailure("Invalid bit set for type \(Element.self)")
			}
			result.append(element)
		}
		return result
	}
	
	var abbreviation: String {
		return elements.map(\.abbreviation).joined(separator: "/")
	}
	
	var first: Element? {
		return rawValue != 0 ? Element(rawValue: rawValue.trailingZeroBitCount) : nil
	}
	
	var fullName: String {
		return elements.map(\.fullName).joined(separator: ", ")
	}
	
	var last: Element? {
		return rawValue != 0 ? Element(rawValue: Int.bitWidth - 1 - rawValue.leadingZeroBitCount) : nil
	}
}

// MARK: Methods
@available(iOS 16.0, macOS 13.0, *)
public extension GrammemeSet {
	
	mutating func insert(abbreviation: String) {
		for singularAbbreviation in abbreviation.split(separator: grammemeAbbreviationSeparator) {
			insert(singularAbbreviation: singularAbbreviation.string)
		}
	}
	
	mutating func insert(singularAbbreviation: String) {
		guard let element = Element(singularAbbreviation) else {
			preconditionFailure("Unable to decode element from '\(singularAbbreviation)'")
		}
		rawValue.setBit(at: element.rawValue)
	}
	
	func contains(_ member: Element) -> Bool {
		rawValue.checkBit(at: member.rawValue)
	}
	
	func union(_ other: __owned Self) -> Self {
		return Self(rawValue: rawValue | other.rawValue)
	}
	
	func intersection(_ other: Self) -> Self {
		return Self(rawValue: rawValue & other.rawValue)
	}
	
	func symmetricDifference(_ other: __owned Self) -> Self {
		return Self(rawValue: rawValue ^ other.rawValue)
	}
	
	@discardableResult mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
		guard !rawValue.checkBit(at: newMember.rawValue) else {
			return (false, newMember)
		}
		rawValue.setBit(at: newMember.rawValue)
		return (true, newMember)
	}
	
	@discardableResult mutating func remove(_ member: Element) -> Element? {
		guard rawValue.checkBit(at: member.rawValue) else {
			return nil
		}
		rawValue.unsetBit(at: member.rawValue)
		return member
	}
	
	@discardableResult mutating func update(with newMember: __owned Element) -> Element? {
		guard !rawValue.checkBit(at: newMember.rawValue) else {
			return newMember
		}
		rawValue.setBit(at: newMember.rawValue)
		return nil
	}
	
	mutating func formUnion(_ other: __owned Self) {
		rawValue |= other.rawValue
	}
	
	mutating func formIntersection(_ other: Self) {
		rawValue &= other.rawValue
	}
	
	mutating func formSymmetricDifference(_ other: __owned Self) {
		rawValue ^= other.rawValue
	}
}

// MARK: Static properties and functions
@available(iOS 16.0, macOS 13.0, *)
public extension GrammemeSet {
}
