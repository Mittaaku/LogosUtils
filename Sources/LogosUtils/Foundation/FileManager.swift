//
//  File.swift
//  LogosUtils
//
//  Created by Tom-Roger Mittag on 5/13/20.
//  Copyright © 2020 TheCrossReference. All rights reserved.
//

#if canImport(Foundation)
import Foundation

public extension FileManager {
    
    enum SystemFolder {
        case bundle(Bundle)
        case documents
        case mainBundle
    }
    
    
    @available(OSX 10.15, *)
    @discardableResult func encode<T: Encodable>(value: T, intoJsonFile file: String, inFolder folder: SystemFolder = .documents, inSubfolder subfolder: String = "", outputFormatting: JSONEncoder.OutputFormatting = [.prettyPrinted, .withoutEscapingSlashes, .sortedKeys]) throws  -> URL {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        let jsonData = try encoder.encode(value)
        let folderUrl = try prepareUrl(toFolder: folder, toSubfolder: subfolder, creatingSubfolders: true)!
        let jsonURL = folderUrl.appendingPathComponent(file)
        try jsonData.write(to: jsonURL)
        LogosUtils.logDebug("Encoded \(T.self) and wrote it to '\(file)'")
        return jsonURL
    }

    
    func decode<T: Decodable>(jsonFile: String, inFolder folder: SystemFolder = .mainBundle, inSubfolder subfolder: String = "", intoType type: T.Type) throws -> T? {
        guard var url = try prepareUrl(toFolder: folder, toSubfolder: subfolder, creatingSubfolders: false) else {
            return nil
        }
        url.appendPathComponent(jsonFile)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let result = try JSONDecoder().decode(T.self, from: data)
        LogosUtils.logDebug("Opened '\(url.lastPathComponent)' and decoded it into '\(T.self)'.")
        return result
    }
    
    
    func prepareUrl(toFolder folder: SystemFolder, toSubfolder subfolder: String = "", creatingSubfolders: Bool) throws -> URL? {
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
