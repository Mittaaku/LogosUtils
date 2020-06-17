//
//  RangeReplaceableCollection.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 6/17/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension RangeReplaceableCollection {

    mutating func append(optionally element: Self.Iterator.Element?) {
        guard let element = element else {
            return
        }
        self.append(element)
    }
}
