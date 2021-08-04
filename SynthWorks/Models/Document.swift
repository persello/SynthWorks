//
//  Document.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import os
import UIKit

class Document: UIDocument, Loggable {
    static let workspaceFileName = "Main.workspace"
    static let wrapperRootKey = "RootKey"

    override var description: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }

    private var fileWrapper: FileWrapper?
    private var openedWorkspace: Workspace?

    // MARK: - Decoded contents
    public func getWorkspace() throws -> Workspace {
        if let cachedWorkspace = openedWorkspace {
            return cachedWorkspace
        }
        
        logger.info("Getting workspace from file wrapper.")
        
        guard fileWrapper != nil else {
            throw DocumentError.mainWorkspaceDecodingError(reason: "FileWrapper is nil")
        }
        
        let data = try decodeFromWrapper(for: Self.workspaceFileName)
        
        if let workspace = data as? Workspace {
            openedWorkspace = workspace
            return workspace
        } else {
            throw DocumentError.mainWorkspaceDecodingError(reason: "Cannot cast workspace to type Workspace")
        }
    }
    
    public func setWorkspace(_ workspace: Workspace) {
        openedWorkspace = workspace
    }

    // MARK: - Wrapper encoding/decoding
    private func encodeToWrapper<T: Encodable>(object: T) throws -> FileWrapper {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        do {
            try archiver.encodeEncodable(object, forKey: Self.wrapperRootKey)
        } catch let error {
            throw DocumentError.objectEncodingError(innerError: error, object: object)
        }

        archiver.finishEncoding()

        return FileWrapper(regularFileWithContents: archiver.encodedData)
    }

    private func decodeFromWrapper(for name: String) throws -> Any? {
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
            throw DocumentError.objectDecodingError(innerError: error, key: name)
        }
    }

    // MARK: - Load/save functions
    override func contents(forType typeName: String) throws -> Any {
        logger.info("Getting contents for type \"\(typeName)\".")
        
        // Prevent overwrite if workspace is nil
        let workspace = try getWorkspace()
        let workspaceWrapper = try encodeToWrapper(object: workspace)
        let wrappers: [String: FileWrapper] = [Self.workspaceFileName: workspaceWrapper]

        return FileWrapper(directoryWithFileWrappers: wrappers)
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        logger.info("Loading document from contents.")

        guard let contents = contents as? FileWrapper else {
            logger.error("The contents passed aren't convertible to FileWrapper.")
            throw DocumentError.contentsAreNotFileWrapper
        }

        fileWrapper = contents
    }
    
    // MARK: - Error handling
    override func handleError(_ error: Error, userInteractionPermitted: Bool) {
        if userInteractionPermitted {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.handle(error, from: nil, retryHandler: nil)
        } else {
            logger.error("\(error.localizedDescription)")
        }
    }
}
