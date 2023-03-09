//
//  LogosUtils
//  Copyright Tom-Roger Mittag 2022.
//

#if canImport(Foundation)
import Foundation

public extension FileManager {

    enum SystemFolder {
        case bundle(Bundle)
        case documents
        case mainBundle
    }

	@available(*, deprecated, message: "Use CodedResource protocol instead")
    @available(OSX 10.15, iOS 13, *)
    @discardableResult func encode<T: Encodable>(value: T, intoJsonFile file: String, inFolder folder: SystemFolder, inSubfolder subfolder: String = "", outputFormatting: JSONEncoder.OutputFormatting = [.prettyPrinted, .withoutEscapingSlashes, .sortedKeys]) throws  -> URL {
        var url = try getUrl(toFolder: folder, toSubfolder: subfolder, creatingSubfolders: true)!
        url.appendPathComponent(file)

        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        let jsonData = try encoder.encode(value)
        try jsonData.write(to: url)
        return url
    }

	@available(*, deprecated, message: "Use CodedResource protocol instead")
    func decode<T: Decodable>(jsonFile: String, intoType type: T.Type, inFolder folder: SystemFolder, inSubfolder subfolder: String = "") throws -> T? {
        guard var url = try getUrl(toFolder: folder, toSubfolder: subfolder, creatingSubfolders: false) else {
            return nil
        }
        url.appendPathComponent(jsonFile)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }

	@available(*, deprecated, message: "Use CodedResource protocol instead")
    func getUrl(toFolder folder: SystemFolder) throws -> URL {
        return try getUrl(toFolder: folder, toSubfolder: "", creatingSubfolders: false)!
    }

	@available(*, deprecated, message: "Use CodedResource protocol instead")
    func getUrl(toFolder folder: SystemFolder, toSubfolder subfolder: String, creatingSubfolders: Bool) throws -> URL? {
        var url: URL
        switch folder {
        case .mainBundle:
            url = Bundle.main.bundleURL
        case .bundle(let bundle):
            url = bundle.bundleURL
        case .documents:
            url = urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        if !subfolder.isEmpty {
            for subdirectory in subfolder.split(separator: "/") {
                url.appendPathComponent(String(subdirectory))
                if !fileExists(atPath: url.path) {
                    if creatingSubfolders {
                        try createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
                    } else {
                        return nil
                    }
                }
            }
        }
        return url
    }
}
#endif
