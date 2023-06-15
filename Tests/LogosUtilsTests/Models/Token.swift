//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
@testable import LogosUtils

@available(macOS 10.15, iOS 13.0, *)
class TokenTests: XCTestCase {
	
	// MARK: - Token Tests
	
	func testTokenDescription() {
		let token = Token(reference: TokenReference(decimalValue: 123), surfaceForm: "word")
		XCTAssertEqual(token.description, "123-word")
	}
	
	func testTokenEquality() {
		let token1 = Token(reference: TokenReference(decimalValue: 123), surfaceForm: "word")
		let token2 = Token(reference: TokenReference(decimalValue: 123), surfaceForm: "word")
		let token3 = Token(reference: TokenReference(decimalValue: 456), surfaceForm: "word")
		
		XCTAssertEqual(token1, token2)
		XCTAssertNotEqual(token1, token3)
	}
	
	func testTokenHashValue() {
		let token = Token(reference: TokenReference(decimalValue: 123), surfaceForm: "word")
		let hashValue = token.hashValue
		
		XCTAssertEqual(hashValue, token.reference.hashValue)
	}
}
