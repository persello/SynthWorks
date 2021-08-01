//
//  Logger.swift
//  Logger
//
//  Created by Riccardo Persello on 01/08/21.
//

import Foundation
import os

extension Logger {
    init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}
