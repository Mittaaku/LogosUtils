//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

#if canImport(Foundation)
import Foundation

public extension Substring {
	/// Converts the substring to a `Bool` value.
	///
	/// The substring is trimmed of leading and trailing whitespaces and newlines before conversion. The following string values are considered `true`: "true", "yes", "1". The following string values are considered `false`: "false", "no", "0". Any other values result in `nil`.
	///
	/// - Returns: The `Bool` value representing the substring, or `nil` if the substring cannot be converted to `Bool`.
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
	
	/// Converts the substring to a `Date` value with the format "yyyy-MM-dd".
	///
	/// The substring is trimmed of leading and trailing whitespaces and newlines before conversion.
	///
	/// - Returns: The `Date` value representing the substring, or `nil` if the substring cannot be converted to `Date`.
	var date: Date? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: selfLowercased)
	}
	
	/// Converts the substring to a `Date` value with the format "yyyy-MM-dd HH:mm:ss".
	///
	/// The substring is trimmed of leading and trailing whitespaces and newlines before conversion.
	///
	/// - Returns: The `Date` value representing the substring, or `nil` if the substring cannot be converted to `Date`.
	var dateTime: Date? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.date(from: selfLowercased)
	}
	
	/// Converts the substring to an `Int` value.
	///
	/// - Returns: The `Int` value representing the substring, or `nil` if the substring cannot be converted to `Int`.
	var int: Int? {
		return Int(self)
	}
	
	/// Converts the substring to a `String` value.
	///
	/// - Returns: The `String` value representing the substring.
	var string: String {
		return String(self)
	}
	
	/// Converts the substring to a `URL` value.
	///
	/// - Returns: The `URL` value representing the substring, or `nil` if the substring cannot be converted to `URL`.
	var url: URL? {
		return URL(string: String(self))
	}
	
	/// Converts the substring to a `Float` value with the specified locale.
	///
	/// - Parameters:
	///   - locale: The locale to use for number formatting. Defaults to the current locale.
	///
	/// - Returns: The `Float` value representing the substring, or `nil` if the substring cannot be converted to `Float`.
	func float(locale: Locale = .current) -> Float? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: String(self))?.floatValue
	}
	
	/// Converts the substring to a `Double` value with the specified locale.
	///
	/// - Parameters:
	///   - locale: The locale to use for number formatting. Defaults to the current locale.
	///
	/// - Returns: The `Double` value representing the substring, or `nil` if the substring cannot be converted to `Double`.
	func double(locale: Locale = .current) -> Double? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: String(self))?.doubleValue
	}
	
	/// Converts the substring to a `CGFloat` value with the specified locale.
	///
	/// - Parameters:
	///   - locale: The locale to use for number formatting. Defaults to the current locale.
	///
	/// - Returns: The `CGFloat` value representing the substring, or `nil` if the substring cannot be converted to `CGFloat`.
	func cgFloat(locale: Locale = .current) -> CGFloat? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: String(self)) as? CGFloat
	}
}

#endif
