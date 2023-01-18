//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import XCTest
import Foundation
import LogosUtils

final class GrammemeTests: XCTestCase {
	
	func testGrammeme() {
		let nominative = GrammaticalCase.nominative
		XCTAssertEqual(nominative.abbreviation, "Nom")
		XCTAssertEqual(nominative.name, "Nominative")
		XCTAssertEqual(nominative.description, "nominative")
		XCTAssertEqual(nominative.codingKey, "n")
	}
}
