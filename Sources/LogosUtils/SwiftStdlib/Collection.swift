//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension Collection {

	func generateCombinations() -> [[Element]] {
		let array = Array(self)
		let fullCombinationBits = 2 ** array.count - 1
		var allCombinations = [[Element]]()
		
		for combinationBits in 0 ... fullCombinationBits {
			var combination = [Element]()
			for arrayIndex in array.indices {
				if combinationBits.checkBit(at: arrayIndex) {
					combination.append(array[arrayIndex])
				}
			}
			allCombinations.append(combination)
		}
		return allCombinations
	}
}

// MARK: - Properties
public extension Collection {

    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}

extension Collection where Element == Substring {
	
	var strings: [String] {
		return map { return String($0) }
	}
}
