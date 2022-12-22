//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public enum UnicodeNormalizationForm {
	case unnormalized
	case decomposedWithCanonicalMapping
	case decomposedWithCompatibilityMapping
	case precomposedWithCanonicalMapping
	case precomposedWithCompatibilityMapping
	
	func convert(string: String) -> String {
		switch self {
		case .unnormalized:
			return string
		case .decomposedWithCanonicalMapping:
			return string.decomposedStringWithCanonicalMapping
		case .decomposedWithCompatibilityMapping:
			return string.decomposedStringWithCompatibilityMapping
		case .precomposedWithCanonicalMapping:
			return string.precomposedStringWithCanonicalMapping
		case .precomposedWithCompatibilityMapping:
			return string.precomposedStringWithCompatibilityMapping
		}
	}
}
