//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension Optional {

    func unwrapped(or defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? defaultValue()
    }

    func unwrapped(or error: @autoclosure () -> Swift.Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
    }

    /// Null-coalescing assignment operator
    static func ??= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        guard lhs == nil else {
            return
        }
        lhs = rhs()
    }
}

infix operator ??= : AssignmentPrecedence
