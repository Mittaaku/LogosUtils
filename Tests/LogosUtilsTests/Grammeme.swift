//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import XCTest
import Foundation
import LogosUtils

@available(iOS 16.0, macOS 13.0, *)
typealias Morphology = LogosUtils.Morphology

final class GrammemeTests: XCTestCase {
	
	func testGrammeme() {
		let nominative = GrammaticalCase.nominative
		XCTAssertEqual(nominative.description, "Nom")
		XCTAssertEqual(nominative.abbreviation, "Nom")
		XCTAssertEqual(nominative.fullName, "Nominative")
		
		let punctuation = Punctuation(character: ".")
		XCTAssertEqual(punctuation, .period)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func testGrammemeSet() {
		var genders: GrammemeSet<Gender> = [.feminine, .masculine]
		XCTAssertTrue(genders.contains(.feminine))
		XCTAssertFalse(genders.contains(.neuter))
		XCTAssertEqual(genders.elements, [.masculine, .feminine])
		
		XCTAssertEqual(nil, genders.remove(.neuter))
		
		XCTAssertEqual(.feminine, genders.remove(.feminine))
		XCTAssertFalse(genders.contains(.feminine))
		XCTAssertEqual(genders.elements, [.masculine])
		
		let insertionResult1 = genders.insert(.feminine)
		XCTAssertEqual(true, insertionResult1.inserted)
		XCTAssertEqual(.feminine, insertionResult1.memberAfterInsert)
		let insertionResult2 = genders.insert(.feminine)
		XCTAssertEqual(false, insertionResult2.inserted)
		XCTAssertEqual(.feminine, insertionResult2.memberAfterInsert)
		XCTAssertTrue(genders.contains(.feminine))
		XCTAssertEqual(genders.elements, [.masculine, .feminine])
		
		genders.insert(abbreviation: "Neut")
		XCTAssertTrue(genders.contains(.neuter))
		
		XCTAssertEqual(genders.union([.neuter]), [.masculine, .feminine, .neuter])
		genders.formUnion([.neuter])
		XCTAssertEqual(genders, [.masculine, .feminine, .neuter])
		
		XCTAssertEqual(genders.symmetricDifference([.neuter]), [.masculine, .feminine])
		genders.formSymmetricDifference([.neuter])
		XCTAssertEqual(genders, [.masculine, .feminine])
		
		XCTAssertEqual(genders.intersection([.masculine]), [.masculine])
		genders.formIntersection([.masculine])
		XCTAssertEqual(genders, [.masculine])
		
		genders.insert(abbreviation: "Neut&Fem")
		XCTAssertEqual(genders, [.masculine, .feminine, .neuter])
		
		genders = GrammemeSet<Gender>.init(abbreviation: "Masc")!
		XCTAssertEqual(genders, [.masculine])
		
		genders = GrammemeSet<Gender>.init(otherSet: genders, abbreviation: "Neut&Fem")
		XCTAssertEqual(genders, [.masculine, .feminine, .neuter])
		
		genders = GrammemeSet<Gender>.init("Masc&Fem")!
		XCTAssertEqual(genders, [.masculine, .feminine])
		XCTAssertEqual(genders.description, "Masc&Fem")
		
		genders = [.masculine, .feminine, .neuter]
		XCTAssertEqual(genders.first, .masculine)
		XCTAssertEqual(genders.last, .neuter)
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func testMorphology() {
		var uncoded = LogosUtils.Morphology()
		uncoded.language = .koineGreek
		uncoded.number = .singular
		uncoded.verbForm = .imperative
		uncoded.wordClass = .adverb
		uncoded.genders = [.masculine, .feminine]
		uncoded.declension = .firstDeclension
		uncoded.person = .third
		uncoded.nounType = .proper
		uncoded.etymology = .biblicalHebrew
		uncoded.degree = .positive
		uncoded.grammaticalCase = .genitive
		uncoded.punctuation = .comma
		uncoded.tense = .perfect
		uncoded.voice = .middlePassive
		XCTAssertEqual(uncoded.description, "G;H;Adv;Imp;Perf;Gen;Masc&Fem;MidPass;3P;Sg;1Decl;Prop;Pos;Comma")
		
		/*
		let codedString = uncoded.description
		let decoded = Morphology(codedString)
		XCTAssertEqual(uncoded, decoded)
		XCTAssertEqual(uncoded.description, decoded?.description)
		 */
	}
	
	@available(iOS 16.0, macOS 13.0, *)
	func testMorphologyDescription() {
		var morph1 = Morphology()
		morph1.wordClass = .verb
		morph1.tense = .imperfect
		morph1.number = .plural
		morph1.voice = .active
		morph1.verbForm = .indicative
		morph1.person = .first
		XCTAssertEqual(morph1.describe(using: .fullName), "Verb Indicative Imperfect Active 1st Person Plural")
		
		var morph2 = Morphology()
		morph2.language = .koineGreek
		morph2.wordClass = .noun
		morph2.gender = .feminine
		morph2.nounType = .proper
		XCTAssertEqual(morph2.describe(using: .fullName), "Proper Greek Noun Feminine")
		
		var morph3 = Morphology()
		morph3.wordClass = .verb
		morph3.tense = .future
		morph3.number = .singular
		morph3.voice = .passive
		morph3.verbForm = .indicative
		morph3.person = .second
		XCTAssertEqual(morph3.describe(using: .abbreviation), "Verb Ind Fut Pass 2P Sg")
	}
}
