//
//  File.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/9/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

import Foundation

public extension NSRegularExpression {

    enum UnicodeCategory: String {
        case han = "Han" // Chinese Hanzi, Japanese Kanji, and Korean Hanja.
        case hiragana = "Hiragana"
        case katakana = "Katakana"
        case latin = "Latin"
        case letter = "L"
        case letterLowercase = "Li"
        case letterUppercase = "Lu"
        case number = "N"
        case numberDecimalDigit = "Nd"
        case whitespace = "Whitespace"
    }
}
