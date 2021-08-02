//
//  Document.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import UIKit
import os

class Document: UIDocument {
    static let workspaceFileName = "Main.workspace"
    static let wrapperRootKey = "RootKey"
    
    private let logger = Logger(category: "Document")
    
    override var description: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }

    private var fileWrapper: FileWrapper?

    // MARK: - Decoded contents
    public lazy var workspace: Workspace = {
        logger.info("Getting workspace from file wrapper.")
        
        guard fileWrapper != nil,
              let data = decodeFromWrapper(for: Self.workspaceFileName) as? Workspace
        else {
            logger.error("Unable to decode main workspace from wrapper since the wrapper is currently nil.")
            fatalError()
        }

        return data
    }()

    // MARK: - Wrapper encoding/decoding
    private func encodeToWrapper<T: Encodable>(object: T) -> FileWrapper {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        do {
            try archiver.encodeEncodable(object, forKey: Self.wrapperRootKey)
        } catch let error {
            logger.error("Unable to encode object: \"\(error.localizedDescription)\".")
            fatalError()
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
            return unarchiver.decodeDecodable(Workspace.self, forKey: Self.wrapperRootKey)
        } catch let error {
            logger.error("Unarchiving failed: \"\(error.localizedDescription)\".")
            fatalError()
        }
    }

    // MARK: - Load/save functions
    override func contents(forType typeName: String) throws -> Any {
        logger.info("Getting contents for type \"\(typeName)\".")
        let workspaceWrapper = encodeToWrapper(object: workspace)
        let wrappers: [String: FileWrapper] = [Self.workspaceFileName: workspaceWrapper]

        return FileWrapper(directoryWithFileWrappers: wrappers)
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        logger.info("Loading document from contents.")
        
        guard let contents = contents as? FileWrapper else {
            logger.error("The contents passed aren't convertible to FileWrapper.")
            return
        }

        fileWrapper = contents
    }
}
