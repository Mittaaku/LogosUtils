//
//  Optional.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/16/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension Optional {

    func unwrapped(or defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? defaultValue()
    }

    func unwrapped(or error: @autoclosure () -> Swift.Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
    }

    /// Null-coalescing assignment operator
    static func ??= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        guard lhs == nil else {
            return
        }
        lhs = rhs()
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

infix operator ??= : AssignmentPrecedence
