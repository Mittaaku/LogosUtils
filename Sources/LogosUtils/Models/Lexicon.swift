//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2023.
//

import Foundation
import GRDB

/// A class representing a Lexicon, which manages a collection of lexemes.
@available(macOS 10.15, iOS 13.0, *)
public class Lexicon: LinguisticDatabaseManager {
	
	// MARK: - Typealiases
	
	public typealias LinguisticUnitType = Lexeme
	
	// MARK: - Properties
	
	/// The database queue used for database operations.
	public let databaseQueue: DatabaseQueue
	
	// MARK: - Initialization
	
	public required init(databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
	}
	
	/// Initializes a Lexicon with the specified lexicon name and folder URL.
	///
	/// - Parameters:
	///   - lexiconName: The name of the lexicon.
	///   - folderURL: The URL of the folder where the lexicon will be stored.
	///
	/// - Warning: If a database with the same name already exists in the specified folder, it will be deleted before creating a new database.
	public init(createNewWithProperties properties: Properties, atFolderURL url: URL) {
		do {
			databaseQueue = try Self.createNewDatabase(properties: properties, folderURL: url)

			try databaseQueue.write { database in
				// Create 'alternativeForms' table
				try database.create(table: Self.alternativeFormsTableName) { table in
					table.primaryKey(Self.alternativeFormColumnName, .text).notNull()
					table.column(Lexeme.lexicalIDColumnName, .text).references(Lexeme.databaseTableName, onDelete: .cascade)
				}
			}
		} catch {
			print("Error creating database queue: \(error)")
			fatalError("Failed to create database queue.")
		}
	}
	
	// MARK: Computed Properties
	
	/// The number of alternative forms in the database.
	public var alternativeFormsCount: Int {
		return countRows(inTable: Self.alternativeFormsTableName)
	}
	
	// MARK: - Database Operations
	
	/// Inserts the specified alternative forms into the lexicon's database for the given lexeme.
	///
	/// - Parameters:
	///   - alternativeForms: The alternative forms to insert.
	///   - lexemeID: The ID of the lexeme associated with the alternative forms.
	public func insert(alternativeForms: [String], for lexemeID: String) {
		do {
			try databaseQueue.write { database in
				for alternativeForm in alternativeForms {
					try database.execute(
						sql: "INSERT INTO \(Self.alternativeFormsTableName) (\(Lexeme.lexicalIDColumnName), \(Self.alternativeFormColumnName)) VALUES (?, ?)",
						arguments: [lexemeID, alternativeForm]
					)
				}
			}
		} catch {
			print("Error inserting alternative forms: \(error)")
		}
	}
	
	/// Fetches all alternative forms for the given lexeme ID.
	///
	/// - Parameter lexemeID: The ID of the lexeme to fetch alternative forms for.
	/// - Returns: An array of alternative forms for the lexeme.
	public func fetchAlternativeForms(for lexemeID: String) -> [String] {
		var alternativeForms: [String] = []
		do {
			try databaseQueue.read { database in
				let query = "SELECT \(Self.alternativeFormColumnName) FROM \(Self.alternativeFormsTableName) WHERE \(Lexeme.lexicalIDColumnName) = ?"
				
				for row in try Row.fetchAll(database, sql: query, arguments: [lexemeID]) {
					if let alternativeForm = row[Self.alternativeFormColumnName] as String? {
						alternativeForms.append(alternativeForm)
					}
				}
			}
		} catch {
			print("Error fetching alternative forms: \(error)")
		}
		return alternativeForms
	}
	
	/// Fetches a lexeme from the lexicon's database by form, matching against both the primary form and alternative forms.
	///
	/// - Parameter form: The form to search for.
	/// - Returns: The fetched lexeme, or `nil` if no lexeme is found.
	public func fetch(byLexicalForm form: String) -> Lexeme? {
		let query = """
 SELECT lexeme.*
 FROM \(Lexeme.databaseTableName)
 LEFT JOIN \(Self.alternativeFormsTableName) ON \(Lexeme.databaseTableName).\(Lexeme.lexicalIDColumnName) = \(Self.alternativeFormsTableName).\(Lexeme.lexicalIDColumnName)
 WHERE \(Lexeme.databaseTableName).\(Lexeme.lexicalFormColumnName) = ? OR \(Self.alternativeFormsTableName).\(Self.alternativeFormColumnName) = ?
 LIMIT 1
 """
		return fetchOne(usingQuery: query, arguments: [form, form])
	}
	
	/// Searches for lexemes in the lexicon's database based on a partial match in the searchMatchingString column.
	///
	/// - Parameter searchTerm: The search term to match.
	/// - Returns: An array of lexemes that match the search term.
	public func searchLexemes(with searchTerm: String) -> [Lexeme] {
		let query = "SELECT * FROM \(Lexeme.databaseTableName) WHERE \(Lexeme.searchMatchingStringColumnName) LIKE ?"
		return fetchAll(usingQuery: query, arguments: ["%\(searchTerm)%"])
	}
	
	// MARK: Static Members and Custom Operators
	
	static let alternativeFormsTableName = "alternativeForms"
	static let alternativeFormColumnName = "alternativeForm"
	
	// MARK: - Nested Types
	
	public struct Properties: LinguisticDatabaseProperties {
		public var name: String
		public var language: Language
		
		static let nameColumn = "name"
		static let languageColumn = "language"
		
		public static func setupTable(inDatabase database: GRDB.Database) throws {
			try database.create(table: Properties.databaseTableName) { table in
				table.primaryKey(nameColumn, .text).notNull()
				table.column(languageColumn, .blob).notNull()
			}
		}
	}
}
