//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 5/16/20.
//

import Foundation

extension Optional {
    func unwrap(orThrow error: @autoclosure () -> Swift.Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
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
