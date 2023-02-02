//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

public prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
	return { !$0[keyPath: keyPath] }
}
