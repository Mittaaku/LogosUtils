//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
@testable import LogosUtils

class LexemeTests: XCTestCase {
	
	func testDescription() {
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "word", gloss: "description")
		XCTAssertEqual(lexeme.description, "1-description")
		
		let lexemeWithoutGloss = Lexeme(lexicalID: "2", lexicalForm: "word")
		XCTAssertEqual(lexemeWithoutGloss.description, "2-?")
	}
	
	func testID() {
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "word")
		XCTAssertEqual(lexeme.id, "1")
	}
	
	func testIsCrasis() {
		var lexeme = Lexeme(lexicalID: "1", lexicalForm: "word")
		XCTAssertFalse(lexeme.isCrasis)
		
		lexeme.crasisLexicalIDs = ["2", "3"]
		XCTAssertTrue(lexeme.isCrasis)
	}
	
	func testHash() {
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "word")
		var hasher = Hasher()
		lexeme.hash(into: &hasher)
		let hashValue = hasher.finalize()
		XCTAssertNotEqual(hashValue, 0)
	}
	
	func testEquality() {
		let lexeme1 = Lexeme(lexicalID: "1", lexicalForm: "word")
		let lexeme2 = Lexeme(lexicalID: "1", lexicalForm: "differentWord")
		let lexeme3 = Lexeme(lexicalID: "2", lexicalForm: "word")
		let lexeme4 = Lexeme(lexicalID: "2", lexicalForm: "word")
		
		XCTAssertEqual(lexeme1, lexeme2)
		XCTAssertNotEqual(lexeme1, lexeme3)
		XCTAssertEqual(lexeme3, lexeme4)
	}
}
