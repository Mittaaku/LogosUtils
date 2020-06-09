//
//  Optional.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/16/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

import Foundation

infix operator ?= : AssignmentPrecedence

public extension Optional {

    func unwrap(or error: @autoclosure () -> Swift.Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
    }

    func unwrap(or defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? defaultValue()
    }

    static func ?= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        if lhs == nil {
            lhs = rhs()
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Optional where Wrapped == String {
    var isNilOrBlank: Bool {
        return self?.isBlank ?? true
    }
}
