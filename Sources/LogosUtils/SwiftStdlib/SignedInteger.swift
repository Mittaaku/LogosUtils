//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 6/8/20.
//

import Foundation

public extension SignedInteger {
    var abs: Self {
        return Swift.abs(self)
    }

    var isPositive: Bool {
        return self > 0
    }

    var isNegative: Bool {
        return self < 0
    }

    var isEven: Bool {
        return (self % 2) == 0
    }

    var isOdd: Bool {
        return (self % 2) != 0
    }
}
