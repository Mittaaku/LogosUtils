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
	let invalidLexeme = Lexeme(lexicalForm: "")
	let batLexeme = Lexeme(
		lexicalID: "1",
		lexicalForm: "bat",
		gloss: "A small flying mammal",
		definition: "A nocturnal mammal capable of sustained flight",
		wordFormMorphologies: [],
		crasisLexicalIDs: []
	)
	let catLexeme = Lexeme(
		lexicalID: "2",
		lexicalForm: "cat",
		gloss: "A small domesticated carnivorous mammal",
		definition: "A small four-legged animal often kept as a pet",
		wordFormMorphologies: [],
		crasisLexicalIDs: [],
		alternativeForms: ["kitten"]
	)
	let dogLexeme = Lexeme(
		lexicalID: "3",
		lexicalForm: "dog",
		gloss: "A domesticated carnivorous mammal",
		definition: "A mammal often kept as a pet or used for guarding or hunting",
		wordFormMorphologies: [],
		crasisLexicalIDs: []
	)
	
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
	
	func testFetchAll() {
		// Insert some lexemes for testing
		lexicon.insert([batLexeme, catLexeme, dogLexeme])
		
		let allLexemes = lexicon.fetchAll()
		
		// Retrieve the number of lexemes and assert the expected count
		XCTAssertEqual(allLexemes.count, 3, "The number of lexemes is incorrect.")
		guard allLexemes.count == 3 else {
			return
		}
		XCTAssertEqual(allLexemes[0].lexicalForm, "bat")
		XCTAssertEqual(allLexemes[1].lexicalForm, "cat")
		XCTAssertEqual(allLexemes[2].lexicalForm, "dog")
	}
	
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
	
	
	func testFetchLexemeByLexicalForm() throws {
		// Insert the lexemes into the lexicon
		lexicon.insert([batLexeme, catLexeme, dogLexeme])
		
		// Fetch a lexeme by lexical form
		let fetchedLexemes = lexicon.fetchAll(withLexicalForm: "cat")
		
		// Assert that the fetched lexeme is not nil
		XCTAssertNotNil(!fetchedLexemes.isEmpty, "Failed to fetch lexeme by lexical form")
		
		// Assert that the fetched lexeme matches the original lexeme
		XCTAssertEqual(fetchedLexemes.first?.lexicalForm, catLexeme.lexicalForm, "The fetched lexeme does not match the original lexeme")
	}
	
	func testFetchLexemeByAlternativeForms() throws {
		// Insert the lexemes into the lexicon
		lexicon.insert([catLexeme])
		
		// Fetch a lexeme by lexical form
		let fetchedLexeme = lexicon.fetchAll(withAlternativeForm: "kitten").first
		
		// Assert that the fetched lexeme is not nil
		XCTAssertNotNil(fetchedLexeme, "Failed to fetch lexeme by lexical form")
		
		// Assert that the fetched lexeme matches the original lexeme
		XCTAssertEqual(fetchedLexeme?.alternativeForms.first, "kitten", "The fetched lexeme does not match the original lexeme")
	}
	
	func testFetchLexemeByID() {
		// Insert the lexeme
		lexicon.insert([catLexeme])
		
		guard let fetchedLexeme = lexicon.fetchAll().first else {
			XCTFail("Lexeme couldn't be fetched")
			return
		}
		
		// Fetch the lexeme by ID
		let fetchedLexemeByID = lexicon.fetchOne(withID: fetchedLexeme.id)
		
		XCTAssertEqual(fetchedLexemeByID?.lexicalForm, "cat", "Failed to fetch lexeme by ID")
	}
	
	func testFetchSingleValue() {
		// Fetch the name from the Lexicon's properties table
		let fetchedName: String? = lexicon.fetchSingleValue(
			inTable: Lexicon.Properties.databaseTableName,
			inColumn: Lexicon.Properties.nameColumn.name
		)
		
		XCTAssertEqual(fetchedName, lexiconProperties.name, "Fetched name does not match the expected value")
	}
	
	func testName() {
		XCTAssertEqual(lexicon.name, lexiconProperties.name, "Lexicon name does not match the expected value")
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
		// Prepare the lexeme to test against
		let lexeme = catLexeme
		
		// Create a temporary folder for the lexicon
		let folderURL = FileManager.default.temporaryDirectory
		let lexiconName = "ReopeningLexicon"
		let lexiconProperties = Lexicon.Properties(name: lexiconName, language: .koineGreek)
		
		// Create a new lexicon and insert a lexeme
		let newLexicon = Lexicon(createNewWithProperties: lexiconProperties, atFolderURL: folderURL)
		newLexicon.insert([lexeme])
		try! newLexicon.databaseQueue.close()
		
		// Open the existing lexicon
		let existingLexicon = Lexicon(openExistingWithName: lexiconName, atFolderURL: folderURL)
		
		// Fetch the previously inserted lexeme
		let fetchedLexeme = existingLexicon.fetchAll().first
		
		XCTAssertEqual(fetchedLexeme?.lexicalForm, lexeme.lexicalForm, "Failed to fetch previously inserted lexeme from existing lexicon")
	}
	
	func testSearchingLexemes() {
		// Insert the lexemes
		lexicon.insert([batLexeme, catLexeme, dogLexeme])
		XCTAssertEqual(lexicon.count, 3, "The number of lexemes is incorrect")
		
		// Search for lexemes matching "domesticated"
		let matchingLexemes = lexicon.searchLexemes(with: "domesticated")
		
		XCTAssertEqual(matchingLexemes.count, 2, "The number of matching lexemes is incorrect")
		XCTAssertTrue(matchingLexemes.contains(where: { $0.lexicalForm == "cat" }), "The matching lexemes do not contain 'cat'")
		XCTAssertTrue(matchingLexemes.contains(where: { $0.lexicalForm == "dog" }), "The matching lexemes do not contain 'dog'")
	}
}
