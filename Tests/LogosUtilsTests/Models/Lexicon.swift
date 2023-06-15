//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
import GRDB
@testable import LogosUtils

class LexiconTests: XCTestCase {
	
	let lexiconName = "TestLexicon"
	let folderURL = FileManager.default.temporaryDirectory
	
	var lexicon: Lexicon!
	var databaseQueue: DatabaseQueue!
	
	override func setUp() {
		super.setUp()

		// Initialize the Lexicon
		lexicon = Lexicon(createNewWithName: lexiconName, atFolderURL: folderURL)
		databaseQueue = lexicon.databaseQueue
	}
	
	override func tearDown() {
		super.tearDown()
		
		// Close the database and release resources
		try! databaseQueue.close()
		databaseQueue = nil
		lexicon = nil
	}
	
	func testcount() {
		// Insert some lexemes for testing
		let lexeme1 = Lexeme(lexicalID: "1", lexicalForm: "cat")
		let lexeme2 = Lexeme(lexicalID: "2", lexicalForm: "dog")
		lexicon.insert(lexeme1, lexeme2)
		
		// Retrieve the number of lexemes and assert the expected count
		let numberOfLexemes = lexicon.count
		XCTAssertEqual(numberOfLexemes, 2, "The number of lexemes is incorrect.")
	}
	
	func testInsertLexemes() {
		// Create some lexemes
		let lexeme1 = Lexeme(
			lexicalID: "1",
			lexicalForm: "cat",
			gloss: "A small domesticated carnivorous mammal",
			definition: "A small four-legged animal often kept as a pet",
			wordFormMorphologies: [],
			crasisLexicalIDs: [],
			searchMatchingString: "cat"
		)
		let lexeme2 = Lexeme(
			lexicalID: "2",
			lexicalForm: "dog",
			gloss: "A domesticated carnivorous mammal",
			definition: "A mammal often kept as a pet or used for guarding or hunting",
			wordFormMorphologies: [],
			crasisLexicalIDs: [],
			searchMatchingString: "dog"
		)
		
		// Insert the lexemes
		let insertionResult = lexicon.insert(lexeme1, lexeme2)
		XCTAssertEqual(insertionResult, true)
		
		// Fetch the lexemes and verify
		let fetchedLexeme1 = lexicon.fetchOne(withID: "1")
		XCTAssertEqual(fetchedLexeme1?.lexicalForm, "cat")
		
		let fetchedLexeme2 = lexicon.fetchOne(withID: "2")
		XCTAssertEqual(fetchedLexeme2?.lexicalForm, "dog")
	}
	
	func testInsertAlternativeForms() {
		// Create a lexeme
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "cat")
		
		// Insert the lexeme
		lexicon.insert(lexeme)
		
		// Insert alternative forms
		lexicon.insert(alternativeForms: ["feline", "kitty"], for: "1")
		
		// Fetch alternative forms for the lexeme
		let alternativeForms = lexicon.fetchAlternativeForms(for: "1")
		
		XCTAssertEqual(alternativeForms.count, 2)
		XCTAssertTrue(alternativeForms.contains("feline"))
		XCTAssertTrue(alternativeForms.contains("kitty"))
	}
	
	func testFetchLexemeByID() {
		// Create a lexeme
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "cat")
		
		// Insert the lexeme
		lexicon.insert(lexeme)
		
		// Fetch the lexeme by ID
		let fetchedLexeme = lexicon.fetchOne(withID: "1")
		
		XCTAssertEqual(fetchedLexeme?.lexicalForm, "cat")
	}
	
	func testFetchLexemeByForm() {
		// Create a lexeme
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "cat")
		
		// Insert the lexeme
		lexicon.insert(lexeme)
		
		// Fetch the lexeme by form
		let fetchedLexeme = lexicon.fetch(byLexicalForm: "cat")
		
		XCTAssertEqual(fetchedLexeme?.lexicalID, "1")
	}
	
	func testFetchSingleValue() {
		XCTAssertEqual(lexicon.fetchSingleValue(inTable: GeneralLinguisticDatabaseColumns.generalTableName, inColumn: GeneralLinguisticDatabaseColumns.nameColumn), lexiconName)
	}
	
	func testSearchLexemes() {
		// Create some lexemes
		let lexeme1 = Lexeme(lexicalID: "1", lexicalForm: "cat")
		let lexeme2 = Lexeme(lexicalID: "2", lexicalForm: "dog")
		let lexeme3 = Lexeme(lexicalID: "3", lexicalForm: "bat")
		
		// Insert the lexemes
		lexicon.insert(lexeme1, lexeme2, lexeme3)
		
		// Search for lexemes matching "at"
		let matchingLexemes = lexicon.searchLexemes(with: "at")
		
		XCTAssertEqual(matchingLexemes.count, 2)
		XCTAssertTrue(matchingLexemes.contains(where: { $0.lexicalForm == "cat" }))
		XCTAssertTrue(matchingLexemes.contains(where: { $0.lexicalForm == "bat" }))
	}
	
	func testName() {
		XCTAssertEqual(lexicon.name, lexiconName)
	}
	
	func testOpenExistingLexicon() {
		// Create a temporary folder for the lexicon
		let folderURL = FileManager.default.temporaryDirectory
		let lexiconName = "ReopeningLexicon"
		
		// Create a new lexicon and insert a lexeme
		let newLexicon = Lexicon(createNewWithName: lexiconName, atFolderURL: folderURL)
		let lexeme = Lexeme(lexicalID: "1", lexicalForm: "apple")
		newLexicon.insert(lexeme)
		try! newLexicon.databaseQueue.close()
		
		// Open the existing lexicon
		let existingLexicon = Lexicon(openExistingWithName: lexiconName, atFolderURL: folderURL)
		
		// Fetch the previously inserted lexeme
		let fetchedLexeme = existingLexicon.fetchOne(withID: "1")
		
		XCTAssertEqual(fetchedLexeme?.lexicalForm, "apple")
	}
	
	func testAddingInvalidLexeme() {
		// Insert some lexemes for testing
		let lexeme1 = Lexeme(lexicalID: "", lexicalForm: "")
		let lexeme2 = Lexeme(lexicalID: "", lexicalForm: "")
		lexicon.insert(lexeme1, lexeme2)
		
		// Retrieve the number of lexemes and assert the expected count
		let numberOfLexemes = lexicon.count
		XCTAssertEqual(numberOfLexemes, 0)
	}
	
	func testInsertDuplicateLexeme() {
		// Create a lexeme
		let lexicalID = "123"
		let lexicalForm = "Car"
		let gloss = "Example gloss"
		let definition = "Example definition"
		let lexeme = Lexeme(lexicalID: lexicalID, lexicalForm: lexicalForm, gloss: gloss, definition: definition)
		
		// Insert the lexeme into the Lexicon
		lexicon.insert(lexeme)
		
		// Attempt to insert the same lexeme again
		lexicon.insert(lexeme)
		
		// Fetch the lexeme from the Lexicon
		let fetchedLexeme = lexicon.fetchOne(withID: lexicalID)
		
		// Ensure that only one instance of the lexeme exists
		XCTAssertEqual(lexicon.count, 1, "There should only be one instance.")
		XCTAssertNotNil(fetchedLexeme, "The lexeme should exist in the Lexicon.")
		XCTAssertEqual(fetchedLexeme?.lexicalID, lexicalID, "The lexicalID of the fetched lexeme should match the inserted lexeme.")
		XCTAssertEqual(fetchedLexeme?.lexicalForm, lexicalForm, "The lexicalForm of the fetched lexeme should match the inserted lexeme.")
		XCTAssertEqual(fetchedLexeme?.gloss, gloss, "The gloss of the fetched lexeme should match the inserted lexeme.")
		XCTAssertEqual(fetchedLexeme?.definition, definition, "The definition of the fetched lexeme should match the inserted lexeme.")
	}
}
