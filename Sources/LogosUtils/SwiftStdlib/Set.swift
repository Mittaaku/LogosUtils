//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

public extension Set where Element: LosslessStringConvertible {
	
	/// An extension for the Set type that allows initializing a set with an encoded string and a regular expression.
	///
	/// The encodedString should be a string that contains elements separated by a delimiter defined by the provided regular expression.
	///
	/// The elements of the set must conform to the LosslessStringConvertible protocol, which means they can be represented as a string and can be initialized from a string representation without loss of information.
	///
	/// Usage:
	/// ```
	/// let encodedString = "1,2,3,4"
	/// let separatorRegex = try! NSRegularExpression(pattern: ",")
	/// let set = Set<Int>(encodedString: encodedString, separatedBy: separatorRegex)
	/// print(set) // Output: [1, 2, 3, 4]
	/// ```
	///
	/// - Parameters:
	///   - encodedString: A string containing the encoded elements separated by the specified delimiter.
	///   - regex: A regular expression used to split the encoded string into individual components.
	///
	/// - Throws:
	///   - preconditionFailure: If an element cannot be decoded from a component of the encoded string.
	///
	/// - Returns: A new set initialized with the elements decoded from the encoded string.
	init(encodedString: String, separatedBy regex: NSRegularExpression) {
		self.init()
		let components = encodedString.split(separator: regex)
		for component in components {
			guard let element = Element(component.string) else {
				preconditionFailure("Unable to decode element from '\(component)'")
			}
			insert(element)
		}
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	init(encodedString: String, separatedBy regex: any RegexComponent) {
		self.init()
		let components = encodedString.split(separator: regex)
		for component in components {
			guard let element = Element(component.string) else {
				preconditionFailure("Unable to decode element from '\(component)'")
			}
			insert(element)
		}
	}
}
#endif
