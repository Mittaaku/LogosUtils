//
//  Set.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/14/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

public extension Set {
    
    static func union(ofSets sets: Self ...) -> Self {
        return sets.reduce(into: Set<Element>()) {
            $0.formUnion($1)
        }
    }
}
