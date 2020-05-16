//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 5/16/20.
//

import Foundation

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
