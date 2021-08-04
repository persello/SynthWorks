//
//  DocumentError.swift
//  DocumentError
//
//  Created by Riccardo Persello on 03/08/21.
//

import Foundation

enum DocumentError: LocalizedError, CategorizedError {
    case cannotSaveBeforeResign
    case cannotSaveDocumentInAppDelegate
    case openingFailure
    case importFailure(Error?)
    
    // MARK: Document class errors
    
    case mainWorkspaceDecodingError(reason: String)
    case objectEncodingError(innerError: Error?, object: Any)
    case objectDecodingError(innerError: Error?, key: String)
    case contentsAreNotFileWrapper
    
    var category: ErrorCategory {
        switch self {
        case .objectEncodingError,
                .objectDecodingError,
                .mainWorkspaceDecodingError,
                .contentsAreNotFileWrapper:
            return .fatal
        default:
            return .nonRetryable
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .cannotSaveBeforeResign:
            return NSLocalizedString(
                "Couldn't save the current file before the application resigned.",
                comment: "saving error on app suspension")
        case .cannotSaveDocumentInAppDelegate:
            return NSLocalizedString(
                "Cannot save document in application delegate. This will prevent some autosave functionality.",
                comment: "can't save document in AppDelegate, trouble ahead")
        case .openingFailure:
            return NSLocalizedString(
                "The file couldn't be opened.",
                comment: "file opening error")
        case let .importFailure(error):
            return NSLocalizedString(
                "During the creation or import of this workspace, the following error occurred: \"\(error?.localizedDescription ?? "Unknown error")\".",
                comment: "import error")
            
        case .mainWorkspaceDecodingError(let reason):
            return NSLocalizedString(
                "Unable to decode main workspace from file wrapper. Reason: \"\(reason)\".",
                comment: "workspace error due to nil file wrapper")
        case let .objectEncodingError(error, object):
            return NSLocalizedString(
                "Error during object encoding. \"\(String(describing: object))\" cannot be encoded due to the following error: \"\(error?.localizedDescription ?? "Unknown error")\".",
                comment: "object encoding generic error")
        case let .objectDecodingError(error, key):
            return NSLocalizedString(
                "Error during object encoding. Key \"\(key)\" cannot be encoded due to the following error: \"\(error?.localizedDescription ?? "Unknown error")\".",
                comment: "object decoding generic error")
        case .contentsAreNotFileWrapper:
            return NSLocalizedString(
                "The contents of this document are not writable as a bundle.",
                comment: "contents of document are not filewrapper")
        }
    }
}

