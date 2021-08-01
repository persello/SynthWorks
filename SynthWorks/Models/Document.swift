//
//  Document.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import UIKit

class Document: UIDocument {
    override var description: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }

    var fileWrapper: FileWrapper?

    lazy var workspace: Workspace = {
        guard fileWrapper != nil,
              let data = decodeFromWrapper(for: "main.aad") as? Workspace
        else {
            fatalError("Unable to decode main workspace from wrapper.")
        }

        return data
    }()

    private func encodeToWrapper<T: Encodable>(object: T) -> FileWrapper {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        do {
            try archiver.encodeEncodable(object, forKey: "Data")
        } catch let error {
            fatalError("Unable to encode object: \(error.localizedDescription)")
        }

        archiver.finishEncoding()

        return FileWrapper(regularFileWithContents: archiver.encodedData)
    }

    private func decodeFromWrapper(for name: String) -> Any? {
        guard let allWrappers = fileWrapper,
              let wrapper = allWrappers.fileWrappers?[name],
              let data = wrapper.regularFileContents
        else {
            return nil
        }

        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            return unarchiver.decodeObject(forKey: "Data")
        } catch let error {
            fatalError("Unarchiving failed. \(error.localizedDescription)")
        }
    }

    override func contents(forType typeName: String) throws -> Any {
        let workspaceWrapper = encodeToWrapper(object: workspace)
        let wrappers: [String: FileWrapper] = ["main.aad": workspaceWrapper]

        return FileWrapper(directoryWithFileWrappers: wrappers)
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let contents = contents as? FileWrapper else { return }

        fileWrapper = contents
    }
}
