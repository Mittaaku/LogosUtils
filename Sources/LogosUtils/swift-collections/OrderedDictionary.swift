//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 01/02/2023.
//

#if canImport(Foundation) && canImport(OrderedDictionary)
import Foundation
import OrderedDictionary

extension OrderedDictionary.Elements {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

extension OrderedDictionary.Values {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
#endif

