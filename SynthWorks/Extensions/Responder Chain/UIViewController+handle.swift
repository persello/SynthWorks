//
//  UIViewController+handle.swift
//  UIViewController+handle
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

extension UIViewController {
    
    
    /// Handles errors that aren't handled by any other view by showing an alert.
    /// - Parameters:
    ///   - error: The error to display.
    ///   - retryHandler: What to do if the error is a `CategorizedError` and of type `.retryable`.
    func handle(_ error: Error,
                retryHandler: (() -> Void)?) {
        handle(error, from: self, retryHandler: retryHandler)
    }
}
