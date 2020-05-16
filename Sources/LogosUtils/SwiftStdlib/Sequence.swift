//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 5/16/20.
//

import Foundation

public extension Sequence {
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
}
