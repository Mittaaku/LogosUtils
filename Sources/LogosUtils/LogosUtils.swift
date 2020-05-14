#if canImport(SwiftyBeaver)
import SwiftyBeaver
#endif

internal struct LogosUtils {
    static func logDebug(_ string: String) {
        #if canImport(SwiftyBeaver)
        log.debug(string)
        #else
        print(string)
        #endif
    }
}


