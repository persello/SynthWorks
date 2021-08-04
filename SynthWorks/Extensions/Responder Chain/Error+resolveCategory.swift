//
//  Error+resolveCategory.swift
//  Error+resolveCategory
//
//  Created by Riccardo Persello on 03/08/21.
//

import Foundation

extension Error {
    func resolveCategory() -> ErrorCategory {
        guard let categorized = self as? CategorizedError else {
            return .nonRetryable
        }

        return categorized.category
    }
}
