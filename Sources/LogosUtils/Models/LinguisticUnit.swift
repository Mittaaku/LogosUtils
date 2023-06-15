//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 08/06/2023.
//

import Foundation
import GRDB

@available(macOS 10.15, iOS 13.0, *)
public protocol LinguisticUnit: Codable, Identifiable, PersistableRecord, FetchableRecord where ID: DatabaseValueConvertible {
	
	func validated() -> Self?
}
