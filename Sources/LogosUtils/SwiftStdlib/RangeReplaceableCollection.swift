//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension RangeReplaceableCollection {

    mutating func append(optionally element: Self.Iterator.Element?) {
        guard let element = element else {
            return
        }
        self.append(element)
    }
}
