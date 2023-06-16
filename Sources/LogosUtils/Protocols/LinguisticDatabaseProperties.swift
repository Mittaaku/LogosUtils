//
//  File.swift
//  
//
//  Created by Tom-Roger Mittag on 15/06/2023.
//

import Foundation
import GRDB

public protocol LinguisticDatabaseProperties: Codable, PersistableRecord, FetchableRecord {
	
	var name: String { get }
	
	var language: Language { get }
	
	static func setupTable(inDatabase database: Database) throws
}
