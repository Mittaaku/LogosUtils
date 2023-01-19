//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension Optional {

    func unwrapped(or error: @autoclosure () -> Swift.Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
    }
}
