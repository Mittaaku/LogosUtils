//
//  CharacterSet.swift
//  
//
//  Created by Tom-Roger Mittag on 21/12/2022.
//

import Foundation

// MARK: Static variables and methods
public extension CharacterSet {
	
	static let diacritics: [Character] = [.acute, .grave, .smoothBreathing, .roughBreathing, .circumflex,  .iotaSubscript]
	
	static let greekLettersWithDiacritics = CharacterSet.generateDiacriticSets(forLetters: "ΑαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσςΤτΥυΦφΧχΨψΩω", addingDiacritics: diacritics)
	
	static let greekLettersWithAcute = greekLettersWithDiacritics[0]
	static let greekLettersWithGrave = greekLettersWithDiacritics[1]
	static let greekLettersWithSmoothBreathing = greekLettersWithDiacritics[2]
	static let greekLettersWithRoughBreathing = greekLettersWithDiacritics[3]
	static let greekLettersWithCircumflex = greekLettersWithDiacritics[4]
	static let greekLettersWithIotaSubscript = greekLettersWithDiacritics[5]
	
	/// LogosUtils: Create a CharacterSet Array by combining the input string with the diacritics.
	/// In the resulting CharacterSet Array, the index of the diacritic in the original Array, will be a index to the CharacterSet containing that diacritic.
	/// Additionally, there will be an additional CharacterSet at the end of the Array containing all of the generated Characters.
	static func generateDiacriticSets(forLetters letters: String, addingDiacritics diacriticCharacters: [Character]) -> [CharacterSet] {
		let diacritics = diacriticCharacters.map { String($0) }
		
		let indexCombinations = Array(0 ..< diacritics.count).generateCombinations()
		var diacriticSets = Array(repeating: CharacterSet(), count: diacritics.count)
		var combinedSet = CharacterSet()
		
		var testing = Array(repeating: [UnicodeScalar](), count: diacritics.count )
		
		for letter in letters {
			for indexCombination in indexCombinations {
				var combinedString = String(letter)
				for index in indexCombination {
					combinedString += diacritics[index]
				}
				// Validate that there is only one decomposed UnicodeScalar
				guard combinedString.count == 1 else {
					continue
				}
				
				// Validate that the UnicodeScalar can be precomposed
				let precomposedString = combinedString.precomposedStringWithCanonicalMapping
				guard let precomposedScalar = precomposedString.unicodeScalars.first, !combinedSet.contains(precomposedScalar) else {
					continue
				}
				
				// Insert the result
				combinedSet.insert(precomposedScalar)
				for index in indexCombination {
					diacriticSets[index].insert(precomposedScalar)
					testing[index].append(precomposedScalar)
				}
			}
		}
		return diacriticSets + [combinedSet]
	}
}

public extension CharacterSet {
	
	func containsPrecomposedUnicodeScalar(of scalar: UnicodeScalar) -> Bool {
		return containsUnicodeScalars(of: String(scalar), precomposed: true)
	}
	
	func containsUnicodeScalar(of character: Character, precomposed: Bool = true) -> Bool {
		return containsUnicodeScalars(of: String(character), precomposed: precomposed)
	}
	
	func containsUnicodeScalars(of string: String, precomposed: Bool = true) -> Bool {
		let stringToEvaluate = precomposed ? string.precomposedStringWithCanonicalMapping : string
		return stringToEvaluate.unicodeScalars.allSatisfy(contains(_:))
	}
}
