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
	public init(createNewWithName name: String, atFolderURL url: URL) {
		do {
			databaseQueue = try Lexicon.createNewDatabase(name: name, folderURL: url)

			try databaseQueue.write { database in
				// Create 'lexeme' table
				try database.create(table: Lexeme.databaseTableName) { table in
					table.primaryKey(Keys.lexicalIDColumn, .text).notNull()
					table.column(Keys.lexicalFormColumn, .text).notNull()
					table.column(Keys.glossColumn, .text)
					table.column(Keys.definitionColumn, .text)
					table.column(Keys.wordFormMorphologiesColumn, .blob)
					table.column(Keys.crasisLexicalIDsColumn, .blob)
					table.column(Keys.searchMatchingStringColumn, .text).notNull()
				}
				
				// Create 'alternativeForms' table
				try database.create(table: Keys.alternativeFormsTableName) { table in
					table.primaryKey(Keys.alternativeFormColumn, .text).notNull()
					table.column(Keys.lexicalIDColumn, .text).references(Lexeme.databaseTableName, onDelete: .cascade)
				}
			}
		} catch {
			print("Error creating database queue: \(error)")
			fatalError("Failed to create database queue.")
		}
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
						sql: "INSERT INTO \(Keys.alternativeFormsTableName) (\(Keys.lexicalIDColumn), \(Keys.alternativeFormColumn)) VALUES (?, ?)",
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
				let query = "SELECT \(Keys.alternativeFormColumn) FROM \(Keys.alternativeFormsTableName) WHERE \(Keys.lexicalIDColumn) = ?"
				
				for row in try Row.fetchAll(database, sql: query, arguments: [lexemeID]) {
					if let alternativeForm = row[Keys.alternativeFormColumn] as String? {
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
 LEFT JOIN \(Keys.alternativeFormsTableName) ON \(Lexeme.databaseTableName).\(Keys.lexicalIDColumn) = \(Keys.alternativeFormsTableName).\(Keys.lexicalIDColumn)
 WHERE \(Lexeme.databaseTableName).\(Keys.lexicalFormColumn) = ? OR \(Keys.alternativeFormsTableName).\(Keys.alternativeFormColumn) = ?
 LIMIT 1
 """
		return fetchOne(usingQuery: query, arguments: [form, form])
	}
	
	/// Searches for lexemes in the lexicon's database based on a partial match in the searchMatchingString column.
	///
	/// - Parameter searchTerm: The search term to match.
	/// - Returns: An array of lexemes that match the search term.
	public func searchLexemes(with searchTerm: String) -> [Lexeme] {
		let query = "SELECT * FROM \(Lexeme.databaseTableName) WHERE \(Keys.searchMatchingStringColumn) LIKE ?"
		return fetchAll(usingQuery: query, arguments: ["%\(searchTerm)%"])
	}
	
	// MARK: - Keys
	
	private enum Keys {
		static let alternativeFormColumn = "alternativeForm"
		static let alternativeFormsTableName = "alternativeForms"
		static let crasisLexicalIDsColumn = "crasisLexicalIDs"
		static let definitionColumn = "definition"
		static let glossColumn = "gloss"
		static let lexicalFormColumn = "lexicalForm"
		static let lexicalIDColumn = "lexicalID"
		static let searchMatchingStringColumn = "searchMatchingString"
		static let wordFormMorphologiesColumn = "wordFormMorphologies"
		static let lexiconNameColumn = "lexiconName"
	}
}
