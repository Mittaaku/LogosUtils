//
//  SignedInteger.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/8/20.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension SignedInteger {
	
    var abs: Self {
        return Swift.abs(self)
    }

    var isNegative: Bool {
        return self < 0
    }
}
