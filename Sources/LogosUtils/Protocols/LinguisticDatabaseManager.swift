//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation
import GRDB

/// A protocol for managing linguistic databases.
@available(macOS 10.15, *)
public protocol LinguisticDatabaseManager: AnyObject {
	
	associatedtype LinguisticUnitType: LinguisticUnit
	associatedtype Properties: LinguisticDatabaseProperties
	
	/// The database queue used for database operations.
	var databaseQueue: DatabaseQueue { get }
	
	/// Initializes a `LinguisticDatabaseManager` with the specified database queue.
	///
	/// - Parameter databaseQueue: The database queue to use for database operations.
	init(databaseQueue: DatabaseQueue)
}

@available(macOS 10.15, *)
extension LinguisticDatabaseManager {
	
	/// Initializes a `LinguisticDatabaseManager` with the specified name and folder URL,
	/// and opens an existing database with the given name and folder URL.
	///
	/// - Parameters:
	///   - name: The name of the database.
	///   - folderURL: The URL of the folder where the database is stored.
	init(openExistingWithName name: String, atFolderURL folderURL: URL) {
		do {
			let databaseQueue = try Lexicon.retrieveDatabasePath(name: name, folderURL: folderURL)
			self.init(databaseQueue: databaseQueue)
		} catch {
			print("Error opening database queue: \(error)")
			fatalError("Failed to open database queue.")
		}
	}
	
	// MARK: - Computed Properties
	
	/// The number of linguistic units (e.g., lexemes, tokens) in the database.
	public var count: Int {
		return countRows(inTable: LinguisticUnitType.databaseTableName)
	}
	
	/// The language of the linguistic database.
	public var language: Language {
		return properties.language
	}
	
	/// The name of the linguistic database.
	public var name: String {
		return properties.name
	}
	
	public var properties: Properties {
		var fetchedUnit: Properties? = nil
		do {
			// Execute the query
			try databaseQueue.read { database in
				fetchedUnit = try Properties.fetchOne(database)
			}
		} catch {
			print("Error fetching \(Properties.self): \(error)")
		}
		return fetchedUnit!
	}
	
	// MARK: - Methods
	
	/// Returns the number of rows in the specified table.
	///
	/// - Parameter table: The name of the table.
	/// - Returns: The count of rows in the table.
	public func countRows(inTable table: String) -> Int {
		var count = 0
		do {
			try databaseQueue.read { database in
				count = try Int.fetchOne(database, sql: "SELECT COUNT(*) FROM \(table)") ?? 0
			}
		} catch {
			print("Error fetching the number of rows: \(error)")
		}
		return count
	}
	
	/// Fetches a single linguistic unit (e.g., lexeme, token) from the database based on the provided ID.
	///
	/// - Parameters:
	///   - query: The SQL query to execute.
	///   - arguments: The arguments to bind to the query.
	/// - Returns: The fetched linguistic unit, or `nil` if none was found.
	public func fetchOne(withID id: LinguisticUnitType.ID) -> LinguisticUnitType? {
		var fetchedUnit: LinguisticUnitType?
		do {
			try databaseQueue.read { database in
				fetchedUnit = try LinguisticUnitType.fetchOne(database, key: id)
			}
		} catch {
			print("Error fetching \(LinguisticUnitType.self): with ID: \(error)")
		}
		return fetchedUnit
	}
	
	/// Fetches a single linguistic unit (e.g., lexeme, token) from the database using the provided query and arguments.
	///
	/// - Parameters:
	///   - query: The SQL query to execute.
	///   - arguments: The arguments to bind to the query.
	/// - Returns: The fetched linguistic unit, or `nil` if none was found.
	public func fetchOne(usingQuery query: String, arguments: StatementArguments) -> LinguisticUnitType? {
		var fetchedUnit: LinguisticUnitType? = nil
		do {
			// Execute the query
			try databaseQueue.read { database in
				fetchedUnit = try LinguisticUnitType.fetchOne(database, sql: query, arguments: arguments)
			}
		} catch {
			print("Error fetching \(LinguisticUnitType.self): \(error)")
		}
		return fetchedUnit
	}
	
	/// Fetches linguistic units (e.g., lexeme, token) from the database using the provided query and arguments.
	///
	/// - Parameters:
	///   - query: The SQL query to execute.
	///   - arguments: The arguments to bind to the query.
	/// - Returns: An array of fetched linguistic units.
	public func fetchAll(usingQuery query: String, arguments: StatementArguments) -> [LinguisticUnitType] {
		var fetchedUnits: [LinguisticUnitType] = []
		do {
			// Execute the query
			try databaseQueue.read { database in
				fetchedUnits = try LinguisticUnitType.fetchAll(database, sql: query, arguments: arguments)
			}
		} catch {
			print("Error fetching \(LinguisticUnitType.self): \(error)")
		}
		return fetchedUnits
	}
	
	/// Fetches a property from the database for the specified table and column.
	///
	/// - Parameters:
	///   - column: The name of the column containing the property.
	///   - table: The name of the table containing the column.
	/// - Returns: The fetched lexicon property, or `nil` if no property is found.
	public func fetchSingleValue<T: DatabaseValueConvertible>(inTable table: String, inColumn column: String) -> T? {
		var fetchedProperty: T?
		do {
			try databaseQueue.read { database in
				let query = "SELECT \(column) FROM \(table)"
				fetchedProperty = try T.fetchOne(database, sql: query)
			}
		} catch {
			print("Error fetching lexicon property in column: \(error)")
		}
		return fetchedProperty
	}
	
	/// Inserts the specified linguistic units into the database using a bulk insert approach.
	///
	/// - Parameter linguisticUnits: An array of linguistic units to insert.
	/// - Returns: A Boolean value indicating whether the insertion was successful for all linguistic units.
	@discardableResult public func insert(_ linguisticUnits: [LinguisticUnitType]) -> Bool {
		var count = 0
		do {
			try databaseQueue.writeWithoutTransaction { database in
				try database.inTransaction {
					for unit in linguisticUnits {
						guard let validated = unit.validated() else {
							print("Attempted to insert an invalid linguistic unit.")
							continue
						}
						try validated.insert(database, onConflict: .replace)
						count += 1
					}
					return .commit
				}
			}
		} catch {
			print("Error inserting \(LinguisticUnitType.self): \(error)")
		}
		
		// Return true if all the linguistic units were successfully added
		return count == linguisticUnits.count
	}

	
	// MARK: - Static Members
	
	/// Creates the path for a linguistic database with the specified name and folder URL.
	///
	/// - Parameters:
	///   - name: The name of the linguistic database.
	///   - folderURL: The URL of the folder where the database will be stored.
	/// - Returns: The new database path.
	private static func createDatabasePath(name: String, folderURL: URL) -> String {
		let folderPath = folderURL.pathComponents.joined(separator: "/")
		return "\(folderPath)/\(name.sanitizedForFileName())"
	}
	
	/// Creates a new linguistic database with the specified properties and folder URL.
	///
	/// - Parameters:
	///   - properties: The properties of the linguistic database.
	///   - folderURL: The URL of the folder where the database will be stored.
	/// - Throws: An error if the database creation fails.
	/// - Returns: The newly created database queue.
	internal static func createNewDatabase(properties: Properties, folderURL: URL) throws -> DatabaseQueue {
		let databasePath = createDatabasePath(name: properties.name, folderURL: folderURL)
		
		// Check if a database with the same name already exists
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: databasePath) {
			// Delete the existing database file
			try fileManager.removeItem(atPath: databasePath)
		}
		
		// Create a new database queue and return it
		let databaseQueue = try DatabaseQueue(path: databasePath)
		
		// Create the table in the database
		try databaseQueue.write { database in
			try LinguisticUnitType.setupTable(inDatabase: database)
			try Properties.setupTable(inDatabase: database)
			try properties.insert(database)
		}
		
		return databaseQueue
	}
	
	/// Retrieves an existing linguistic database with the specified name and folder URL.
	///
	/// - Parameters:
	///   - name: The name of the linguistic database.
	///   - folderURL: The URL of the folder where the database is stored.
	/// - Throws: An error if the database retrieval fails.
	/// - Returns: The retrieved database queue.
	internal static func retrieveDatabasePath(name: String, folderURL: URL) throws -> DatabaseQueue {
		let databasePath = createDatabasePath(name: name, folderURL: folderURL)
		
		// Check if a database with the specified name exists
		let fileManager = FileManager.default
		guard fileManager.fileExists(atPath: databasePath) else {
			print("Database not found.")
			fatalError("Failed to find the database.")
		}
		
		// Open the existing database queue and return it
		let databaseQueue = try DatabaseQueue(path: databasePath)
		return databaseQueue
	}
}
