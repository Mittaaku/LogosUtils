//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
@testable import LogosUtils

class LexemeTests: XCTestCase {
	
	func testLexemeDescription() {
		let lexeme = Lexeme(lexicalForm: "apple")
		
		XCTAssertEqual(lexeme.description, "(Lexeme: apple)")
	}
	
	func testLexemeIsCrasis() {
		var lexeme = Lexeme(lexicalForm: "apple")
		
		XCTAssertFalse(lexeme.isCrasis)
		
		lexeme.crasisLexicalIDs = [1, 2, 3]
		
		XCTAssertTrue(lexeme.isCrasis)
	}
	
	func testLexemeHash() {
		let lexeme1 = Lexeme(lexicalForm: "apple")
		let lexeme2 = Lexeme(lexicalForm: "apple")
		
		XCTAssertEqual(lexeme1.hashValue, lexeme2.hashValue)
	}
	
	func testLexemeValidated() {
		var lexeme = Lexeme(lexicalForm: "apple")
		lexeme.alternativeForms = ["fruit"]
		lexeme.gloss = "A round fruit"
		
		let validatedLexeme = lexeme.validated()
		
		XCTAssertNotNil(validatedLexeme)
		XCTAssertEqual(validatedLexeme?.searchableStrings, ["apple", "A round fruit", "fruit"])
	}
	
	// MARK: - Lexeme Equatable Tests
	
	func testLexemeAlternativeForms() {
		var lexeme = Lexeme(lexicalForm: "apple")
		
		// Test initial state
		XCTAssertTrue(lexeme.alternativeForms.isEmpty)
		
		// Add alternative forms
		lexeme.alternativeForms = ["fruit", "pomme", "apfel"]
		
		XCTAssertEqual(lexeme.alternativeForms, ["fruit", "pomme", "apfel"])
		
		// Update alternative forms
		lexeme.alternativeForms.append("manzana")
		
		XCTAssertEqual(lexeme.alternativeForms, ["fruit", "pomme", "apfel", "manzana"])
		
		// Test projected value
		XCTAssertEqual(lexeme.$alternativeForms, "fruit\tpomme\tapfel\tmanzana")
	}

}
