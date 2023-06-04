//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 03/06/2023.
//

import Foundation

import XCTest

final class SubstringExtensionsTests: XCTestCase {
	
	func testBoolConversion() {
		XCTAssertEqual("true".suffix(4).bool, true)
		XCTAssertEqual("yes".suffix(3).bool, true)
		XCTAssertEqual("1".suffix(1).bool, true)
		
		XCTAssertEqual("false".suffix(5).bool, false)
		XCTAssertEqual("no".suffix(2).bool, false)
		XCTAssertEqual("0".suffix(1).bool, false)
		
		XCTAssertNil("foo".suffix(3).bool)
		XCTAssertNil("".suffix(0).bool)
	}
	
	func testDateConversion() {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd"
		
		XCTAssertEqual("2023-06-03".suffix(10).date, formatter.date(from: "2023-06-03"))
		
		XCTAssertNil("foo".suffix(3).date)
		XCTAssertNil("".suffix(0).date)
	}
	
	func testDateTimeConversion() {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		XCTAssertEqual("2023-06-03 12:34:56".suffix(19).dateTime, formatter.date(from: "2023-06-03 12:34:56"))
		
		XCTAssertNil("foo".suffix(3).dateTime)
		XCTAssertNil("".suffix(0).dateTime)
	}
	
	func testIntConversion() {
		XCTAssertEqual("42".suffix(2).int, 42)
		
		XCTAssertNil("foo".suffix(3).int)
		XCTAssertNil("".suffix(0).int)
	}
	
	func testStringConversion() {
		XCTAssertEqual("Hello".suffix(5).string, "Hello")
		XCTAssertEqual("".suffix(0).string, "")
	}
	
	func testURLConversion() {
		XCTAssertEqual("https://www.example.com".suffix(23).url, URL(string: "https://www.example.com"))
		XCTAssertNil("".suffix(0).url)
	}
	
	func testFloatConversion() {
		XCTAssertEqual("3,14".suffix(4).float(locale: Locale(identifier: "fr_FR")), 3.14)
		
		XCTAssertNil("foo".suffix(3).float())
		XCTAssertNil("".suffix(0).float())
	}
	
	func testDoubleConversion() {
		XCTAssertEqual("3,14159".suffix(7).double(locale: Locale(identifier: "fr_FR")), 3.14159)
		
		XCTAssertNil("foo".suffix(3).double())
		XCTAssertNil("".suffix(0).double())
	}
	
	func testCGFloatConversion() {
		XCTAssertEqual("3,14".suffix(4).cgFloat(locale: Locale(identifier: "fr_FR")), CGFloat(3.14))
		
		XCTAssertNil("foo".suffix(3).cgFloat())
		XCTAssertNil("".suffix(0).cgFloat())
	}
}
