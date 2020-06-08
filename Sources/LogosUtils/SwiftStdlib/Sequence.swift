//
//  Sequence.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/16/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

import Foundation

public extension Sequence {
    
    func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try !condition($0) }
    }
    
    func all(by keyPath: KeyPath<Element, Bool>) -> Bool {
        return all { $0[keyPath: keyPath] }
    }
    
    func any(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try contains { try condition($0) }
    }
    
    func any(by keyPath: KeyPath<Element, Bool>) -> Bool {
        return any { $0[keyPath: keyPath] }
    }
    
    func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try condition($0) }
    }
    
    func none(by keyPath: KeyPath<Element, Bool>) -> Bool {
        return none { $0[keyPath: keyPath] }
    }
    
    func filter(by keyPath: KeyPath<Element, Bool>) -> [Element] {
        return filter { $0[keyPath: keyPath] }
    }
    
    func reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !condition($0) }
    }
    
    func reject(by keyPath: KeyPath<Element, Bool>) -> [Element] {
        return reject { $0[keyPath: keyPath] }
    }
    
    func map<T>(by keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
    
    func compactMap<T>(by keyPath: KeyPath<Element, T?>) -> [T] {
        return compactMap { $0[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(ascendingBy keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted {
            return $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }
    
    func sorted<T: Comparable>(descendingBy keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted {
            return $0[keyPath: keyPath] > $1[keyPath: keyPath]
        }
    }
}
