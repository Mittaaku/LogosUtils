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
		} catch {
			print("Error creating database queue: \(error)")
			fatalError("Failed to create database queue.")
		}
	}
	
	// MARK: - Database Operations
	
	/// Fetches a lexeme from the lexicon's database by primary lexical form
	///
	/// - Parameter form: The form to search for.
	/// - Returns: The fetched lexeme, or `nil` if no lexeme is found.
	public func fetchLexeme(withLexicalForm form: String) -> Lexeme? {
		var result: Lexeme? = nil
		do {
			try databaseQueue.read { database in
				result = try Lexeme
					.filter(Lexeme.lexicalFormColumn == form)
					.fetchOne(database)
			}
		} catch {
			print("Error fetching lexeme by lexical form: \(error)")
		}
		return result
	}
	
	/// Fetches lexemes from the lexicon's database by alternative lexical forms.
	///
	/// - Parameter form: The form to search for.
	/// - Returns: The fetched lexeme, or `nil` if no lexeme is found.
	public func fetchLexemes(withAlternativeForm form: String) -> [Lexeme] {
		let searchPattern = "%\(form)%"
		var result = [Lexeme]()
		do {
			try databaseQueue.read { database in
				result = try Lexeme
					.filter(Lexeme.alternativeFormsColumn.like(searchPattern))
					.fetchAll(database)
			}
		} catch {
			print("Error fetching lexeme by lexical form: \(error)")
		}
		
		// Filter the results further to check for word boundaries
		result = result.filter { $0.alternativeForms.contains(form) }
		
		// TODO: Optimize
		
		return result
	}
	
	/// Searches for lexemes in the lexicon's database based on a partial match in the searchMatchingString column.
	///
	/// - Parameter searchTerm: The search term to match.
	/// - Returns: An array of lexemes that match the search term.
	public func searchLexemes(with searchTerm: String) -> [Lexeme] {
		let searchPattern = "%\(searchTerm)%"
		var result = [Lexeme]()
		do {
			try databaseQueue.read { database in
				result = try Lexeme
					.filter(Lexeme.searchableStringsColumn.like(searchPattern))
					.fetchAll(database)
			}
		} catch {
			print("Error fetching lexeme: \(error)")
		}
		return result
	}
	
	// MARK: - Nested Types
	
	public struct Properties: LinguisticDatabaseProperties {
		public var name: String
		public var language: Language
		
		static let nameColumn = Column(CodingKeys.name)
		static let languageColumn = Column(CodingKeys.language)
		
		public static func setupTable(inDatabase database: GRDB.Database) throws {
			try database.create(table: Properties.databaseTableName) { table in
				table.primaryKey(nameColumn.name, .text).notNull()
				table.column(languageColumn.name, .blob).notNull()
			}
		}
	}
}
