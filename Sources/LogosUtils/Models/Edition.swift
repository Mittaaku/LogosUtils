//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//
import Foundation
import GRDB

/// A class representing an edition of a linguistic database.
@available(macOS 10.15, iOS 13.0, *)
public class Edition: LinguisticDatabaseManager {
	
	public typealias LinguisticUnitType = Token
	
	/// The database queue used for database operations.
	public var databaseQueue: DatabaseQueue
	
	/// Creates an instance of `Edition` with the provided database queue.
	///
	/// - Parameter databaseQueue: The database queue to use.
	public required init(databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
	}
	
	/// Creates a new edition of a linguistic database with the specified name and folder URL.
	///
	/// - Parameters:
	///   - name: The name of the new edition.
	///   - url: The folder URL where the database will be stored.
	public init(createNewWithProperties properties: Properties, atFolderURL url: URL) {
		do {
			databaseQueue = try Edition.createNewDatabase(properties: properties, folderURL: url)
		} catch {
			print("Error creating database queue: \(error)")
			fatalError("Failed to create database queue.")
		}
	}
	
	/// Fetches the token at the specific token reference, if any.
	///
	/// - Parameter ref: The reference.
	/// - Returns: The token found at the specific reference, if any.
	public func fetchOne(atReference ref: TokenReference) -> Token? {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Token.referenceColumnName) == ?"
		return fetchOne(usingQuery: query, arguments: [ref])
	}
	
	/// Fetches tokens within the specified reference.
	///
	/// - Parameter ref: The reference range.
	/// - Returns: An array of tokens within the reference range.
	public func fetchAll(inReference ref: some BibleReferenceContainer) -> [Token] {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Token.referenceColumnName) >= ? AND \(Token.referenceColumnName) < ? ORDER BY \(Token.referenceColumnName) ASC"
		return fetchAll(usingQuery: query, arguments: [ref, ref.next])
	}
	
	/// Fetches tokens within the specified range.
	///
	/// - Parameter range: The half-open range of reference values.
	/// - Returns: An array of tokens within the reference range.
	public func fetchAll(inRange range: Range<some BibleReferenceContainer>) -> [Token] {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Token.referenceColumnName) >= ? AND \(Token.referenceColumnName) < ? ORDER BY \(Token.referenceColumnName) ASC"
		return fetchAll(usingQuery: query, arguments: [range.lowerBound, range.upperBound])
	}
	
	/// Fetches tokens within the specified closed range.
	///
	/// - Parameter range: The closed range of reference values.
	/// - Returns: An array of tokens within the reference range.
	public func fetchAll(inRange range: ClosedRange<some BibleReferenceContainer>) -> [Token] {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Token.referenceColumnName) >= ? AND \(Token.referenceColumnName) < ? ORDER BY \(Token.referenceColumnName) ASC"
		return fetchAll(usingQuery: query, arguments: [range.lowerBound, range.upperBound.next])
	}
	
	/// Inserts the specified token into the database using a bulk insert approach.
	///
	/// - Parameter tokens: An array of tokens to insert.
	/// - Returns: A Boolean value indicating whether the insertion was successful for all tokens.
	@discardableResult public func insert(_ tokens: [Token]) -> Bool {
		var count = 0
		do {
			try databaseQueue.writeWithoutTransaction { database in
				try database.inTransaction {
					for token in tokens {
						guard let validated = token.makeValidated() else {
							print("Attempted to insert an invalid token.")
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
		return count == tokens.count
	}
	
	// MARK: - Nested Types
	
	public struct Properties: LinguisticDatabaseProperties {
		public var name: String
		public var language: Language
		
		public init(name: String, language: Language) {
			self.name = name
			self.language = language
		}
		
		static let nameColumnName = "name"
		static let languageColumnName = "language"
		
		public static func setupTable(inDatabase database: GRDB.Database) throws {
			try database.create(table: Properties.databaseTableName) { table in
				table.primaryKey(nameColumnName, .text).notNull()
				table.column(languageColumnName, .blob).notNull()
			}
		}
	}
}
