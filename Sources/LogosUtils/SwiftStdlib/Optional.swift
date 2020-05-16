//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 5/16/20.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional where Wrapped == String {
    var isNilOrBlank: Bool {
        return self?.isBlank ?? true
    }
}
