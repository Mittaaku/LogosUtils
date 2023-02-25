//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

//  Some of the abbreviations used for the various keys are from these links (in order of priority):
//  1. https://en.wikipedia.org/wiki/List_of_glossing_abbreviations
//  2. https://www.abbreviations.com/

import Foundation

public protocol GrammemeEnum: GrammemeType, CaseIterable {
	var abbreviations: [String] { get }
	
	static var caseByAbbreviation: [String: Self] { get }
}

public extension GrammemeEnum {
	
	init?(abbreviation: String) {
		guard let grammeme = Self.caseByAbbreviation[abbreviation] else {
			return nil
		}
		self = grammeme
	}
	
	var abbreviation: String {
		return abbreviations[0]
	}
	
	var fullName: String {
		guard let result = getEnumCaseName(for: self) else {
			fatalError("Unable to get case name for enum'")
		}
		return result.camelCaseToCapitalized
	}
}

// ---------------------------------------------------
// MARK: Declension
// ---------------------------------------------------
public enum Declension: Int, GrammemeEnum {
	case firstDeclension
	case secondDeclension
	case thirdDeclension
	case indeclinableNumber
	case indeclinableLetter
}

public extension Declension {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	static var declinableSet: Set<Self> = [.firstDeclension, .secondDeclension, .thirdDeclension]
	
	var abbreviations: [String] {
		switch self {
		case .firstDeclension:
			return ["1Decl"]
		case .secondDeclension:
			return ["2Decl"]
		case .thirdDeclension:
			return ["3Decl"]
		case .indeclinableNumber:
			return ["IndeclNum", "IN", "NUI"]
		case .indeclinableLetter:
			return ["IndeclLet", "IL", "LI"]
		}
	}
	
	var isDeclinable: Bool {
		return Self.declinableSet.contains(self)
	}
}

// ---------------------------------------------------
// MARK: Etymology
// ---------------------------------------------------
public enum Etymology: Int, GrammemeEnum {
	case aramaic
	case greek
	case hebrew
}

public extension Etymology {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .aramaic:
			return ["A"]
		case .greek:
			return ["G"]
		case .hebrew:
			return ["H"]
		}
	}
}

// ---------------------------------------------------
// MARK: Grammatical Case
// ---------------------------------------------------
public enum GrammaticalCase: Int, GrammemeEnum {
	case nominative
	case accusitive
	case genitive
	case dative
	case vocative
}

public extension GrammaticalCase {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .nominative:
			return ["Nom", "N"]
		case .genitive:
			return ["Gen", "G"]
		case .dative:
			return ["Dat", "D"]
		case .accusitive:
			return ["Acc", "A"]
		case .vocative:
			return ["Voc", "V"]
		}
	}
}

// ---------------------------------------------------
// MARK: Grammatical Degree
// ---------------------------------------------------
public enum GrammaticalDegree: Int, GrammemeEnum {
	case positive
	case comparative
	case superlative
}

public extension GrammaticalDegree {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .positive:
			return ["Pos", "P", "N"]
		case .comparative:
			return ["Comp", "C"]
		case .superlative:
			return ["Supl", "S"]
		}
	}
}

// ---------------------------------------------------
// MARK: Gender
// ---------------------------------------------------
public enum Gender: Int, GrammemeEnum {
	case masculine
	case feminine
	case neuter
	case common
}

public extension Gender {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .masculine:
			return ["Masc", "M", "m"]
		case .feminine:
			return ["Fem", "F", "f"]
		case .neuter:
			return ["Neut", "N"]
		case .common:
			return ["Comm", "C", "c", "b"]
		}
	}
	
	var greekArticle: String {
		switch self {
		case .masculine:
			return "ὁ"
		case .feminine:
			return "ἡ"
		case .neuter:
			return "τό"
		default:
			return ""
		}
	}
}

// ---------------------------------------------------
// MARK: Greek Tense
// ---------------------------------------------------
public enum Tense: Int, GrammemeEnum {
	case aorist
	case future
	case imperfect
	case perfect
	case pluperfect
	case present
	case secondAorist
	case secondFuture
	case secondImperfect
	case secondPerfect
	case secondPluperfect
	case secondPresent
}

public extension Tense {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .aorist:
			return ["Aor", "A"]
		case .future:
			return ["Fut", "F"]
		case .imperfect:
			return ["Imperf", "I"]
		case .perfect:
			return ["Perf", "R"]
		case .pluperfect:
			return ["Pluperf", "L"]
		case .present:
			return ["Pres", "P"]
		case .secondAorist:
			return ["2Aor", "2A"]
		case .secondFuture:
			return ["2Fut", "2F"]
		case .secondImperfect:
			return ["2Imperf", "2I"]
		case .secondPerfect:
			return ["2Perf", "2R"]
		case .secondPluperfect:
			return ["2Pluperf", "2L"]
		case .secondPresent:
			return ["2Pres", "2P"]
		}
	}
}

// ---------------------------------------------------
// MARK: Verb Mode (including mood)
// ---------------------------------------------------
public enum VerbForm: Int, GrammemeEnum {
	// Non-finite forms
	case infinitive
	case participle
	// Finite moods
	case imperative
	case indicative
	case optative
	case subjunctive
}

public extension VerbForm {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .infinitive:
			return ["Inf", "N"]
		case .participle:
			return ["Pcp", "P"]
		case .imperative:
			return ["Imp", "M"]
		case .indicative:
			return ["Ind", "I"]
		case .optative:
			return ["Opt", "O"]
		case .subjunctive:
			return ["Sbjv", "S"]
		}
	}
}

// ---------------------------------------------------
// MARK: Hebrew State
// ---------------------------------------------------
public enum HebrewState: Int, GrammemeEnum {
	case absolute
	case construct
}

public extension HebrewState {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .absolute:
			return ["Abs", "a"]
		case .construct:
			return ["Con", "c"]
		}
	}
}

// ---------------------------------------------------
// MARK: Hebrew Verb Mode
// ---------------------------------------------------
public enum HebrewVerbMode: Int, GrammemeEnum {
	case infinitive
	case imperative
	case imperfect
	case imperfectConjunction
	case imperfectConsecutive
	case participle
	case participlePassive
	case perfect
	case perfectConsecutive
}

public extension HebrewVerbMode {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .infinitive:
			return ["Inf", "c", "a"]
		case .imperative:
			return ["Imp", "v"]
		case .imperfect:
			return ["Imperf", "i"]
		case .imperfectConjunction:
			return ["ImperfConj", "u"]
		case .imperfectConsecutive:
			return ["ImperfConsec", "w"]
		case .participle:
			return ["Pcp", "r"]
		case .participlePassive:
			return ["PcpPass", "s"]
		case .perfect:
			return ["Perf", "p"]
		case .perfectConsecutive:
			return ["PerfConsec", "q"]
		}
	}
}

// ---------------------------------------------------
// MARK: Hebrew Verb Stem
// ---------------------------------------------------
public enum HebrewVerbStem: Int, GrammemeEnum {
	case qal
	case niphal
	case piel
	case pual
	case hithpael
	case hothpaal
	case nithpael
	case hiphil
	case tiphil
	case hophal
}

public extension HebrewVerbStem {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .qal:
			return  ["Qal", "q"]
		case .niphal:
			return  ["Nip", "N"]
		case .piel:
			return  ["Pie", "p"]
		case .pual:
			return  ["Pua", "P"]
		case .hithpael:
			return  ["Hit", "t"]
		case .hothpaal:
			return  ["Hot", "u"]
		case .nithpael:
			return  ["Nit", "D"]
		case .hiphil:
			return  ["Hip", "h"]
		case .tiphil:
			return  ["Tip", "c"]
		case .hophal:
			return  ["Hop", "H"]
		}
	}
	
	var action: String {
		switch self {
		case .qal, .niphal, .hithpael:
			return "Simple"
		case .piel, .pual, .hothpaal, .nithpael:
			return "Intensive"
		case .hiphil, .tiphil, .hophal:
			return "Causative"
		}
	}
	
	var voice: String {
		switch self {
		case .qal, .piel, .hiphil, .tiphil:
			return "Active"
		case .niphal:
			return "Passive/Reflexive"
		case .pual, .hophal, .hothpaal:
			return "Passive"
		case .hithpael, .nithpael:
			return "Reflexive"
		}
	}
}

// ---------------------------------------------------
// MARK: Number
// ---------------------------------------------------
public enum Number: Int, GrammemeEnum {
	// sourcery: codingKey
	case singular
	// sourcery: codingKey
	case dual
	// sourcery: codingKey
	case plural
}

public extension Number {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .singular:
			return ["Sg", "S", "s"]
		case .dual:
			return ["Du", "D", "d"]
		case .plural:
			return ["Pl", "P", "p"]
		}
	}
}

// ---------------------------------------------------
// MARK: Person
// ---------------------------------------------------
public enum Person: Int, GrammemeEnum {
	case firstPerson
	case secondPerson
	case thirdPerson
}

public extension Person {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .firstPerson:
			return ["1", "1st"]
		case .secondPerson:
			return ["2", "2nd"]
		case .thirdPerson:
			return ["3", "3rd"]
		}
	}
}

// ---------------------------------------------------
// MARK: Noun Type
// ---------------------------------------------------
public enum NounType: Int, GrammemeEnum {
	case common
	case commonNumeral
	case commonNumeralPosition
	case properTitle
	case properTitleGentilic
	case properLocation
	case properLocationGentilic
	case properPerson
	case properPersonGentilic
}

public extension NounType {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	static var properSet: Set<Self> = [.properTitle, .properTitleGentilic, .properLocation, .properLocationGentilic, .properPerson, .properPersonGentilic]
	
	var abbreviations: [String] {
		switch self {
		case .common:
			return ["Comm", "a"]
		case .commonNumeral:
			return ["CommNum", "c"]
		case .commonNumeralPosition:
			return ["CommNumPos", "o"]
		case .properTitle:
			return ["PropTitle", "T"]
		case .properTitleGentilic:
			return ["PropTitleG", "TG"]
		case .properLocation:
			return ["PropLoc", "L"]
		case .properLocationGentilic:
			return ["PropLocG", "LG"]
		case .properPerson:
			return ["PropPer", "P"]
		case .properPersonGentilic:
			return ["PropPerG", "PG"]
		}
	}
	
	var isProperNoun: Bool {
		return Self.properSet.contains(self)
	}
}

// ---------------------------------------------------
// MARK: Punctuation
// ---------------------------------------------------
public enum Punctuation: Int, GrammemeEnum {
	case unknown
	case paragraphMark
	case period
	case comma
	case semicolon
	case questionMark
	case hyphen
	case parenthesisOpen
	case parenthesisClose
	case bracketsOpen
	case bracketsClose
	case doubleBracketsOpen
	case doubleBracketsClose
	case verseEnd
	case paseq
	case sectionMark
}

public extension Punctuation {
	
	init?(character: String) {
		guard let value = Self.caseByCharacter[character] else {
			return nil
		}
		self = value
	}
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	static var caseByCharacter = makeDictionaryUsingValue(\.characters)
	
	static var separators: Set<Punctuation> = [.period, .comma, .semicolon, .questionMark, .paseq, .verseEnd, .sectionMark]
	static var dashes: Set<Punctuation> = [.hyphen]
	static var openers: Set<Punctuation> = [.parenthesisOpen, .bracketsOpen, .doubleBracketsOpen]
	static var closers: Set<Punctuation> = [.parenthesisClose, .bracketsClose, .doubleBracketsClose]
	static var leadingSpaceSet = Set<Punctuation>(unionOf: [openers])
	static var trailingSpaceSet = Set<Punctuation>(unionOf: [closers, separators])
	
	var abbreviations: [String] {
		switch self {
		case .unknown:
			return ["Unknown"]
		case .paragraphMark:
			return ["Para"]
		case .period:
			return ["Period"]
		case .comma:
			return ["Comma"]
		case .semicolon:
			return ["Semicolon"]
		case .questionMark:
			return ["Question"]
		case .hyphen:
			return ["Hyphen"]
		case .parenthesisOpen:
			return ["POpen"]
		case .parenthesisClose:
			return ["PClose"]
		case .bracketsOpen:
			return ["BOpen"]
		case .bracketsClose:
			return ["BClose"]
		case .doubleBracketsOpen:
			return ["DBOpen"]
		case .doubleBracketsClose:
			return ["DBClose"]
		case .verseEnd:
			return ["VerseEnd"]
		case .paseq:
			return ["Paseq"]
		case .sectionMark:
			return ["Sect"]
		}
	}
	
	var characters: [String] {
		switch self {
		case .unknown:
			return ["׆"]
		case .paragraphMark:
			return ["¶", "פ"]
		case .period:
			return ["."]
		case .comma:
			return [","]
		case .semicolon:
			return ["·"]
		case .questionMark:
			return [";"]
		case .hyphen:
			return ["—", "־"]
		case .parenthesisOpen:
			return ["("]
		case .parenthesisClose:
			return [")"]
		case .bracketsOpen:
			return ["["]
		case .bracketsClose:
			return ["]"]
		case .doubleBracketsOpen:
			return ["[["]
		case .doubleBracketsClose:
			return ["]]"]
		case .verseEnd:
			return ["׃"]
		case .paseq:
			return ["׀"]
		case .sectionMark:
			return ["ס"]
		}
	}
	
	var hasLeadingSpace: Bool {
		return Self.leadingSpaceSet.contains(self)
	}
	
	var hasTrailingSpace: Bool {
		return Self.trailingSpaceSet.contains(self)
	}
}

// ---------------------------------------------------
// MARK: Voice
// ---------------------------------------------------
public enum Voice: Int, GrammemeEnum {
	case active
	case activeImpersonal
	case middle
	case middleDeponent
	case middlePassive
	case middlePassiveDeponent
	case passive
	case passiveDeponent
	case indefinite
}

public extension Voice {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .active:
			return ["Act", "A"]
		case .activeImpersonal:
			return ["ActImprs", "Q"]
		case .middle:
			return ["Mid", "M"]
		case .middleDeponent:
			return ["MidDep", "D"]
		case .middlePassive:
			return ["MidPass", "E"]
		case .middlePassiveDeponent:
			return ["MidPassDep", "N"]
		case .passive:
			return ["Pass", "P"]
		case .passiveDeponent:
			return ["PassDep", "O"]
		case .indefinite:
			return ["Indf", "X"]
		}
	}
}

// ---------------------------------------------------
// MARK: Word Category
// ---------------------------------------------------
public enum WordClass: Int, GrammemeEnum {
	
	// MARK: Pronouns
	case correlativePronoun
	case correlativeInterrogativePronoun
	case demonstrativePronoun
	case impersonalPronoun
	case indefinitePronoun
	case interrogativePronoun
	case personalPronoun
	case posessivePronoun
	case reciprocalPronoun
	case reflexivePronoun
	case relativePronoun
	
	// MARK: Suffixes
	case directionalSuffix
	case paragogicSuffix
	case personalObjectPronounSuffix
	case personalPosessivePronounSuffix
	case personalSubjectPronounSuffix
	
	// MARK: Particles
	case particle
	case interrogativeParticle
	case negativeParticle
	case objectMarkingParticle
	
	// MARK: Prespositions
	case preposition
	case definitivePreposition
	
	// MARK: Conjunctions
	case conjunction
	case consecutiveConjunction
	
	// MARK: Other
	case adjective
	case adverb
	case article
	case compoundWord
	case conditional
	case interjection
	case noun
	case punctuation
	case verb
}

public extension WordClass {
	
	static var caseByAbbreviation = makeDictionaryUsingValue(\.abbreviations)
	
	var abbreviations: [String] {
		switch self {
		case .correlativePronoun:
			return ["CorP"]
		case .correlativeInterrogativePronoun:
			return ["CorIntP"]
		case .demonstrativePronoun:
			return ["DemP"]
		case .impersonalPronoun:
			return ["ImpP"]
		case .indefinitePronoun:
			return ["IndP"]
		case .interrogativePronoun:
			return ["IntP"]
		case .personalPronoun:
			return ["PerP"]
		case .posessivePronoun:
			return ["PosP"]
		case .reciprocalPronoun:
			return ["RecP"]
		case .reflexivePronoun:
			return ["RefP"]
		case .relativePronoun:
			return ["RelP"]
		case .directionalSuffix:
			return ["DirSuf"]
		case .paragogicSuffix:
			return ["ParSuf"]
		case .personalObjectPronounSuffix:
			return ["ObjSuf"]
		case .personalPosessivePronounSuffix:
			return ["PosSuf"]
		case .personalSubjectPronounSuffix:
			return ["SubSuf"]
		case .particle:
			return ["Part"]
		case .interrogativeParticle:
			return ["IntPart"]
		case .negativeParticle:
			return ["NegPart"]
		case .objectMarkingParticle:
			return ["ObjPart"]
		case .preposition:
			return ["Prep"]
		case .definitivePreposition:
			return ["DefPrep"]
		case .conjunction:
			return ["Conj"]
		case .consecutiveConjunction:
			return ["ConConj"]
		case .adjective:
			return ["Adj"]
		case .adverb:
			return ["Adv"]
		case .article:
			return ["Art"]
		case .compoundWord:
			return ["Compound"]
		case .conditional:
			return ["Cond"]
		case .interjection:
			return ["Intj"]
		case .noun:
			return ["Noun"]
		case .punctuation:
			return ["Punct"]
		case .verb:
			return ["Verb"]
		}
	}
}
