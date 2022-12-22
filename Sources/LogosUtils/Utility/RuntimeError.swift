//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public struct RuntimeError: Error {
    let message: String

    public init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
