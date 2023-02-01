//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

import Foundation

prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
	return { !$0[keyPath: keyPath] }
}
