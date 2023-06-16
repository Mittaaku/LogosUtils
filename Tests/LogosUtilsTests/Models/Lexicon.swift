//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
import GRDB
@testable import LogosUtils

class LexiconTests: XCTestCase {
	
	let folderURL = FileManager.default.temporaryDirectory
	let lexiconProperties = Lexicon.Properties(
		name: "TestLexicon",
		language: Language.english
	)
	let batLexeme = Lexeme(
		lexicalID: "b",
		lexicalForm: "bat",
		gloss: "A small flying mammal",
		definition: "A nocturnal mammal capable of sustained flight",
		wordFormMorphologies: [],
		crasisLexicalIDs: []
	)
	let catLexeme = Lexeme(
		lexicalID: "c",
		lexicalForm: "cat",
		gloss: "A small domesticated carnivorous mammal",
		definition: "A small four-legged animal often kept as a pet",
		wordFormMorphologies: [],
		crasisLexicalIDs: []
	)
	let dogLexeme = Lexeme(
		lexicalID: "d",
		lexicalForm: "dog",
		gloss: "A domesticated carnivorous mammal",
		definition: "A mammal often kept as a pet or used for guarding or hunting",
		wordFormMorphologies: [],
		crasisLexicalIDs: []
	)
	let invalidLexeme = Lexeme(lexicalID: "", lexicalForm: "")
	
	var lexicon: Lexicon!
	var databaseQueue: DatabaseQueue!
	
	override func setUpWithError() throws {
		super.setUp()
		
		// Initialize the Lexicon
		lexicon = Lexicon(createNewWithProperties: lexiconProperties, atFolderURL: folderURL)
		databaseQueue = lexicon.databaseQueue
	}
	
	override func tearDownWithError() throws {
		super.tearDown()
		
		// Close the database and release resources
		try databaseQueue.close()
		databaseQueue = nil
		lexicon = nil
	}
	
	// MARK: - Test Methods
	
	func testInsertingInvalidLexemeDoesNotIncreaseCount() {
		// Insert an invalid lexeme and assert that the count remains 0
		lexicon.insert([invalidLexeme])
		
		XCTAssertEqual(lexicon.count, 0, "Inserting an invalid lexeme should not increase the count")
	}
	
	func testCountLexemes() {
		// Insert some lexemes for testing
		lexicon.insert([catLexeme, dogLexeme])
		
		// Retrieve the number of lexemes and assert the expected count
		XCTAssertEqual(lexicon.count, 2, "The number of lexemes is incorrect.")
	}
	
	func testFetchingAlternativeForms() throws {
		// Prepare the lexeme to test against
		let lexeme = catLexeme
		
		// Insert the lexeme into the lexicon
		lexicon.insert([catLexeme])
		
		// Insert alternative forms for the lexeme
		lexicon.insert(alternativeForms: ["kitty", "pussycat"], for: lexeme.lexicalID)
		
		// Fetch alternative forms for the lexeme
		let alternativeForms = lexicon.fetchAlternativeForms(for: lexeme.lexicalID)
		
		// Assert that the fetched alternative forms match the expected forms
		XCTAssertEqual(alternativeForms, ["kitty", "pussycat"])
	}
	
	func testFetchLexemeByLexicalForm() throws {
		// Insert the lexemes into the lexicon
		lexicon.insert([batLexeme, catLexeme, dogLexeme])
		
		// Fetch a lexeme by lexical form
		let fetchedLexeme = lexicon.fetch(byLexicalForm: "cat")
		
		// Assert that the fetched lexeme is not nil
		XCTAssertNotNil(fetchedLexeme, "Failed to fetch lexeme by lexical form")
		
		// Assert that the fetched lexeme matches the original lexeme
		XCTAssertEqual(fetchedLexeme, catLexeme, "The fetched lexeme does not match the original lexeme")
	}
	
	func testFetchLexemeByID() {
		// Insert the lexeme
		lexicon.insert([catLexeme])
		
		// Fetch the lexeme by ID
		let fetchedLexeme = lexicon.fetchOne(withID: "c")
		
		XCTAssertEqual(fetchedLexeme?.lexicalForm, "cat", "Failed to fetch lexeme by ID")
	}
	
	func testFetchSingleValue() {
		// Fetch the name from the Lexicon's properties table
		let fetchedName: String? = lexicon.fetchSingleValue(
			inTable: Lexicon.Properties.databaseTableName,
			inColumn: Lexicon.Properties.nameColumn
		)
		
		XCTAssertEqual(fetchedName, lexiconProperties.name, "Fetched name does not match the expected value")
	}
	
	func testName() {
		XCTAssertEqual(lexicon.name, lexiconProperties.name, "Lexicon name does not match the expected value")
	}
	
	func testInsertingAlternativeFormIncreasesCount() throws {
		// Prepare the lexeme to test against
		let lexeme = catLexeme
		
		// Insert the lexeme into the lexicon
		lexicon.insert([lexeme])
		
		// Insert an alternative form for the lexeme
		let alternativeForm = "kitty"
		lexicon.insert(alternativeForms: [alternativeForm], for: lexeme.lexicalID)
		
		// Assert that the count increases after inserting the alternative form
		XCTAssertEqual(lexicon.alternativeFormsCount, 1, "The count should increase after inserting an alternative form")
	}
	
	func testInsertingDuplicateLexemeDoesNotIncreaseCount() {
		// Prepare the lexeme to test against
		let lexeme = catLexeme
		
		// Insert the lexeme into the Lexicon
		lexicon.insert([lexeme])
		
		// Attempt to insert the same lexeme again
		lexicon.insert([lexeme])
		
		// Assert that the count remains 1 and the lexeme exists in the Lexicon
		XCTAssertEqual(lexicon.count, 1, "There should only be one instance of the lexeme")
		XCTAssertNotNil(lexicon.fetchOne(withID: lexeme.lexicalID), "The lexeme should exist in the Lexicon")
	}
	
	func testInsertingLexemeIncreasesCount() {
		// Insert the lexemes
		lexicon.insert([catLexeme, dogLexeme])
		
		// Assert that the count increases after inserting the lexemes
		XCTAssertEqual(lexicon.count, 2, "The count should increase after inserting the lexemes")
	}
	
	func testLanguage() {
		XCTAssertEqual(lexicon.language, lexiconProperties.language, "Lexicon language does not match the expected value")
	}
	
	func testOpeningExistingLexicon() {
		// Create a temporary folder for the lexicon
		let folderURL = FileManager.default.temporaryDirectory
		let lexiconName = "ReopeningLexicon"
		let lexiconProperties = Lexicon.Properties(name: lexiconName, language: .koineGreek)
		
		// Create a new lexicon and insert a lexeme
		let newLexicon = Lexicon(createNewWithProperties: lexiconProperties, atFolderURL: folderURL)
		newLexicon.insert([catLexeme])
		try! newLexicon.databaseQueue.close()
		
		// Open the existing lexicon
		let existingLexicon = Lexicon(openExistingWithName: lexiconName, atFolderURL: folderURL)
		
		// Fetch the previously inserted lexeme
		let fetchedLexeme = existingLexicon.fetchOne(withID: "c")
		
		XCTAssertEqual(fetchedLexeme?.lexicalForm, "cat", "Failed to fetch previously inserted lexeme from existing lexicon")
	}
	
	func testSearchingLexemes() {
		// Insert the lexemes
		lexicon.insert([batLexeme, catLexeme, dogLexeme])
		
		// Search for lexemes matching "domesticated"
		let matchingLexemes = lexicon.searchLexemes(with: "domesticated")
		
		XCTAssertEqual(matchingLexemes.count, 2, "The number of matching lexemes is incorrect")
		XCTAssertTrue(matchingLexemes.contains(where: { $0.lexicalForm == "cat" }), "The matching lexemes do not contain 'cat'")
		XCTAssertTrue(matchingLexemes.contains(where: { $0.lexicalForm == "dog" }), "The matching lexemes do not contain 'dog'")
	}
}
