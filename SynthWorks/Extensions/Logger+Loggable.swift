//
//  Logger+Loggable.swift
//  Logger+Loggable
//
//  Created by Riccardo Persello on 01/08/21.
//

import Foundation
import os
import UIKit

extension Logger {
    init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}

protocol Loggable {}

extension Loggable {
    var logger: Logger {
        return Logger(category: String(describing: type(of: self)))
    }
}
