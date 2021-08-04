//
//  CategorizedError.swift
//  CategorizedError
//
//  Created by Riccardo Persello on 03/08/21.
//

import Foundation

enum ErrorCategory {
    case retryable
    case nonRetryable
    case fatal
}

protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}
