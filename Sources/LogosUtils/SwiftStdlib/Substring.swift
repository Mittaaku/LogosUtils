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

// MARK: - Properties
public extension Substring {
	
#if canImport(Foundation)
	/// LogosUtils: Bool value from substring (if applicable).
	///
	///		"1".bool -> true
	///		"False".bool -> false
	///		"Hello".bool = nil
	///
	var bool: Bool? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		switch selfLowercased {
		case "true", "yes", "1":
			return true
		case "false", "no", "0":
			return false
		default:
			return nil
		}
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Date object from "yyyy-MM-dd" formatted substring.
	///
	///		"2007-06-29".date -> Optional(Date)
	///
	var date: Date? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: selfLowercased)
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Date object from "yyyy-MM-dd HH:mm:ss" formatted substring.
	///
	///		"2007-06-29 14:23:09".dateTime -> Optional(Date)
	///
	var dateTime: Date? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.date(from: selfLowercased)
	}
#endif
	
	/// LogosUtils: Integer value from substring (if applicable).
	///
	///		"101".int -> 101
	///
	var int: Int? {
		return Int(self)
	}
	
	/// LogosUtils: String value from substring.
	var string: String {
		return String(self)
	}
	
#if canImport(Foundation)
	/// LogosUtils: Get URL from substring (if applicable).
	///
	///		"https://google.com".url -> URL(string: "https://google.com")
	///		"not url".url -> nil
	///
	var url: URL? {
		return URL(string: String(self))
	}
#endif
}

// MARK: - Methods
public extension Substring {
#if canImport(Foundation)
	/// LogosUtils: Float value from substring (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional Float value from given string.
	func float(locale: Locale = .current) -> Float? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: String(self))?.floatValue
	}
#endif
	
#if canImport(Foundation)
	/// LogosUtils: Double value from substring (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional Double value from given string.
	func double(locale: Locale = .current) -> Double? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: String(self))?.doubleValue
	}
#endif
	
#if canImport(CoreGraphics) && canImport(Foundation)
	/// LogosUtils: CGFloat value from substring (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional CGFloat value from given string.
	func cgFloat(locale: Locale = .current) -> CGFloat? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: String(self)) as? CGFloat
	}
#endif
}
