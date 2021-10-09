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
    /// Creates a new `Logger` in the current application's subsystem.
    /// - Parameter category: The logger's category.
    init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}


/// This protocol implements a default `Logger` with the name of the class as the category.
///
/// A class marked with `Loggable` presents a preconfigured `logger` variable which can be used to log messages to the console.
protocol Loggable {}

extension Loggable {
    var logger: Logger {
        return Logger(category: String(describing: type(of: self)))
    }
}
