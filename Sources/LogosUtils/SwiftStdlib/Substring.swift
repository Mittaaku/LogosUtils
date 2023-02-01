//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if canImport(SwifterSwift)
import SwifterSwift
#endif

// MARK: - Properties
public extension Substring {
#if canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: Bool value from substring (if applicable).
	///
	///		"1".bool -> true
	///		"False".bool -> false
	///		"Hello".bool = nil
	///
	var bool: Bool? {
		return String(self).bool
	}
#endif
	
#if canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: Date object from "yyyy-MM-dd" formatted substring.
	///
	///		"2007-06-29".date -> Optional(Date)
	///
	var date: Date? {
		return String(self).date
	}
#endif
	
#if canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: Date object from "yyyy-MM-dd HH:mm:ss" formatted substring.
	///
	///		"2007-06-29 14:23:09".dateTime -> Optional(Date)
	///
	var dateTime: Date? {
		return String(self).dateTime
	}
#endif
	
#if canImport(SwifterSwift)
	/// LogosUtils: Integer value from substring (if applicable).
	///
	///		"101".int -> 101
	///
	var int: Int? {
		return String(self).int
	}
#endif
	
	/// LogosUtils: String value from substring.
	var string: String {
		return String(self)
	}
	
#if canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: Get URL from substring (if applicable).
	///
	///		"https://google.com".url -> URL(string: "https://google.com")
	///		"not url".url -> nil
	///
	var url: URL? {
		return String(self).url
	}
#endif
}

// MARK: - Methods
public extension Substring {
#if canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: Float value from substring (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional Float value from given string.
	func float(locale: Locale = .current) -> Float? {
		return String(self).float(locale: locale)
	}
#endif
	
#if canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: Double value from substring (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional Double value from given string.
	func double(locale: Locale = .current) -> Double? {
		return String(self).double(locale: locale)
	}
#endif
	
#if canImport(CoreGraphics) && canImport(Foundation) && canImport(SwifterSwift)
	/// LogosUtils: CGFloat value from substring (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional CGFloat value from given string.
	func cgFloat(locale: Locale = .current) -> CGFloat? {
		return String(self).cgFloat(locale: locale)
	}
#endif
}
