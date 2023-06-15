//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import XCTest
import GRDB
@testable import LogosUtils

@available(macOS 10.15, iOS 13.0, *)
class EditionTests: XCTestCase {
	
	let editionName = "TestEdition"
	let folderURL = FileManager.default.temporaryDirectory
	
	var databaseQueue: DatabaseQueue!
	var edition: Edition!
	
	override func setUp() {
		super.setUp()
		
		// Initialize the Edition
		edition = Edition(createNewWithName: editionName, atFolderURL: folderURL)
		databaseQueue = edition.databaseQueue
	}
	
	override func tearDown() {
		// Close and release the database queue
		databaseQueue = nil
		edition = nil
		
		super.tearDown()
	}
	
	func testFetchTokens() {
		// Prepare test data
		let reference1 = TokenReference(book: 1, chapter: 1, verse: 1, token: 1)
		let token1 = Token(reference: reference1, surfaceForm: "Token 1")
		let token2 = Token(reference: token1.reference.next, surfaceForm: "Token 2")
		let token3 = Token(reference: token2.reference.next, surfaceForm: "Token 3")
		let token4 = Token(reference: TokenReference(book: 1, chapter: 1, verse: 2, token: 1), surfaceForm: "Token 4")
		
		// Insert test tokens into the database
		let insertionResult = edition.insert(token1, token2, token3, token4)
		XCTAssertTrue(insertionResult)
		
		// Assert number of items in database
		XCTAssertEqual(edition.count, 4)
		
		// Fetch tokens in the reference range
		let fetchedTokens = edition.fetchTokens(inReference: reference1.verseReference)
		
		// Assert the fetched tokens
		if fetchedTokens.count == 3 {
			XCTAssertEqual(fetchedTokens[0], token1)
			XCTAssertEqual(fetchedTokens[1], token2)
			XCTAssertEqual(fetchedTokens[2], token3)
		} else {
			XCTFail("Invalid number of tokens: \(fetchedTokens.count)")
		}
	}
	
	func testFetchTokensInRange() {
		// Prepare test data
		let reference1 = TokenReference(book: 1, chapter: 1, verse: 1, token: 1)
		let reference2 = TokenReference(book: 1, chapter: 1, verse: 1, token: 2)
		let reference3 = TokenReference(book: 1, chapter: 1, verse: 1, token: 3)
		let token1 = Token(reference: reference1, surfaceForm: "Token 1")
		let token2 = Token(reference: reference2, surfaceForm: "Token 2")
		let token3 = Token(reference: reference3, surfaceForm: "Token 3")
		
		// Insert test tokens into the database
		XCTAssertTrue(edition.insert(token1, token2, token3))
		
		// Fetch tokens in the range
		let range1 = reference1..<reference3
		let fetchedTokens1 = edition.fetchTokens(inRange: range1)
		
		// Assert the fetched tokens
		XCTAssertEqual(fetchedTokens1.count, 2)
		XCTAssertEqual(fetchedTokens1[0], token1)
		XCTAssertEqual(fetchedTokens1[1], token2)
		
		// Fetch tokens in the range
		let range2 = reference1...reference3
		let fetchedTokens2 = edition.fetchTokens(inRange: range2)
		
		// Assert the fetched tokens
		XCTAssertEqual(fetchedTokens2.count, 3)
		XCTAssertEqual(fetchedTokens2[0], token1)
		XCTAssertEqual(fetchedTokens2[1], token2)
		XCTAssertEqual(fetchedTokens2[2], token3)
	}
}
