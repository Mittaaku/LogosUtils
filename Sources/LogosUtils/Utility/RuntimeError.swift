//
//  RuntimeError.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 15/03/2021.
//  Copyright © Tom-Roger Mittag. All rights reserved.
//

import Foundation

public struct RuntimeError: Error {
    let message: String

    public init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
