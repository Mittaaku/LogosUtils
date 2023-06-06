//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 06/06/2023.
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
