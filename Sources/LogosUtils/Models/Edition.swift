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
	public init(createNewWithName name: String, atFolderURL url: URL) {
		do {
			databaseQueue = try Edition.createNewDatabase(name: name, folderURL: url)
			
			try databaseQueue.write { database in
				// Create 'tokens' table
				try database.create(table: Token.databaseTableName) { table in
					table.primaryKey(Keys.referenceColumn, .integer).notNull()
					table.column(Keys.relatedReferenceColumn, .integer)
					table.column(Keys.surfaceFormColumn, .text).notNull()
					table.column(Keys.lexicalIDColumn, .text)
					table.column(Keys.morphologiesColumn, .blob)
					table.column(Keys.translationColumn, .text)
				}
			}
		} catch {
			print("Error creating database queue: \(error)")
			fatalError("Failed to create database queue.")
		}
	}
	
	/// Fetches the token at the specific token reference, if any.
	///
	/// - Parameter ref: The reference.
	/// - Returns: The token found at the specific reference, if any.
	public func fetchToken(atReference ref: TokenReference) -> Token? {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Keys.referenceColumn) == ?"
		return fetchOne(usingQuery: query, arguments: [ref])
	}
	
	/// Fetches tokens within the specified reference.
	///
	/// - Parameter ref: The reference range.
	/// - Returns: An array of tokens within the reference range.
	public func fetchTokens(inReference ref: some BibleReferenceContainer) -> [Token] {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Keys.referenceColumn) >= ? AND \(Keys.referenceColumn) < ? ORDER BY \(Keys.referenceColumn) ASC"
		return fetchAll(usingQuery: query, arguments: [ref, ref.next])
	}
	
	/// Fetches tokens within the specified range.
	///
	/// - Parameter range: The half-open range of reference values.
	/// - Returns: An array of tokens within the reference range.
	public func fetchTokens(inRange range: Range<some BibleReferenceContainer>) -> [Token] {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Keys.referenceColumn) >= ? AND \(Keys.referenceColumn) < ? ORDER BY \(Keys.referenceColumn) ASC"
		return fetchAll(usingQuery: query, arguments: [range.lowerBound, range.upperBound])
	}
	
	/// Fetches tokens within the specified closed range.
	///
	/// - Parameter range: The closed range of reference values.
	/// - Returns: An array of tokens within the reference range.
	public func fetchTokens(inRange range: ClosedRange<some BibleReferenceContainer>) -> [Token] {
		let query = "SELECT * FROM \(Token.databaseTableName) WHERE \(Keys.referenceColumn) >= ? AND \(Keys.referenceColumn) < ? ORDER BY \(Keys.referenceColumn) ASC"
		return fetchAll(usingQuery: query, arguments: [range.lowerBound, range.upperBound.next])
	}
	
	// MARK: - Keys
	
	private enum Keys {
		static let referenceColumn = "reference"
		static let relatedReferenceColumn = "relatedReference"
		static let surfaceFormColumn = "surfaceForm"
		static let lexicalIDColumn = "lexicalID"
		static let morphologiesColumn = "morphologies"
		static let translationColumn = "translation"
	}
}
