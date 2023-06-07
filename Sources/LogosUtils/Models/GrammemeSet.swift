//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation

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
	
	// MARK: - Computed properties
	
	public var abbreviation: String {
		return elements.map(\.abbreviation).joined(separator: separatingCharacter)
	}
	
	public var count: Int {
		return elements.count
	}
	
	public var elements: [Element] {
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
	
	public var first: Element? {
		return rawValue != 0 ? Element(rawValue: rawValue.trailingZeroBitCount) : nil
	}
	
	public var fullName: String {
		return elements.map(\.fullName).joined(separator: ", ")
	}
	
	public var last: Element? {
		return rawValue != 0 ? Element(rawValue: Int.bitWidth - 1 - rawValue.leadingZeroBitCount) : nil
	}
	
	// MARK: - Methods
	
	public func contains(_ member: Element) -> Bool {
		rawValue.checkBit(at: member.rawValue)
	}
	
	public mutating func insert(abbreviation: String) {
		for singularAbbreviation in abbreviation.split(separator: separatingRegex) {
			insert(singularAbbreviation: singularAbbreviation.string)
		}
	}
	
	@discardableResult public mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
		guard !rawValue.checkBit(at: newMember.rawValue) else {
			return (false, newMember)
		}
		rawValue.setBit(at: newMember.rawValue)
		return (true, newMember)
	}
	
	public mutating func insert(singularAbbreviation: String) {
		guard let element = Element(singularAbbreviation) else {
			preconditionFailure("Unable to decode element from '\(singularAbbreviation)'")
		}
		rawValue.setBit(at: element.rawValue)
	}
	
	@discardableResult public mutating func remove(_ member: Element) -> Element? {
		guard rawValue.checkBit(at: member.rawValue) else {
			return nil
		}
		rawValue.unsetBit(at: member.rawValue)
		return member
	}
	
	@discardableResult public mutating func update(with newMember: __owned Element) -> Element? {
		guard !rawValue.checkBit(at: newMember.rawValue) else {
			return newMember
		}
		rawValue.setBit(at: newMember.rawValue)
		return nil
	}
	
	// MARK: - Merging methods
	
	public func union(_ other: __owned Self) -> Self {
		return Self(rawValue: rawValue | other.rawValue)
	}
	
	public func intersection(_ other: Self) -> Self {
		return Self(rawValue: rawValue & other.rawValue)
	}
	
	public func symmetricDifference(_ other: __owned Self) -> Self {
		return Self(rawValue: rawValue ^ other.rawValue)
	}
	
	public mutating func formUnion(_ other: __owned Self) {
		rawValue |= other.rawValue
	}
	
	public mutating func formIntersection(_ other: Self) {
		rawValue &= other.rawValue
	}
	
	public mutating func formSymmetricDifference(_ other: __owned Self) {
		rawValue ^= other.rawValue
	}
	
	// MARK: - Static members
	
	public let separatingRegex = NSRegularExpression(#"\&"#)
	
	public let separatingCharacter = #"&"#
}
