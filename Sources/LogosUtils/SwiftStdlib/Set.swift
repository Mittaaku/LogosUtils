//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public extension Set where Element: LosslessStringConvertible {
	
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
