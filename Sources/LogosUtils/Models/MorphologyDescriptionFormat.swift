//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public enum MorphologyDescriptionFormat {
	case abbreviation
	case commaDelineatedAbbreviation
	case fullName
	case commaDelineatedFullName
	
	var deliniator: String {
		switch self {
		case .abbreviation, .fullName:
			return " "
		case .commaDelineatedAbbreviation, .commaDelineatedFullName:
			return ", "
		}
		
	}
}


