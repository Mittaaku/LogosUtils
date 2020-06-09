//
//  Collection.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/14/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

public extension Collection {

    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
