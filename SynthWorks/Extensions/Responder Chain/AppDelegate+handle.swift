//
//  AppDelegate+handle.swift
//  AppDelegate+handle
//
//  Created by Riccardo Persello on 03/08/21.
//

import os
import UIKit

extension AppDelegate {
    
    /// Handles errors that aren't handled by any other view by showing an alert.
    /// - Parameters:
    ///   - error: The error to display.
    ///   - viewController: Optionally, pass a `UIViewController` if there's one available. Otherwise, if we are (for example) in the document browser, a new window and a new controlled are created. A `UIViewController` is necessary to display an alert.
    ///   - retryHandler: What to do if the error is a `CategorizedError` and of type `.retryable`.
    override func handle(_ error: Error, from viewController: UIViewController?, retryHandler: (() -> Void)?) {
        
        var alertContainingViewController: UIViewController
        
        // Create a window and a view controller if we are outside one (ex. AppDelegate).
        if let viewController = viewController {
            alertContainingViewController = viewController
        } else {
            let delegate = UIApplication.shared.delegate as! AppDelegate
                
            // Se non è zuppa è pan bagnato.
            alertContainingViewController = delegate.currentViewController ?? (delegate.window?.rootViewController)!
        }
        
        // Create a logger from the controller name. It won't make any sense if we are outside a controller.
        let logger: Logger = Logger(category: String(describing: type(of: alertContainingViewController)))
        logger.error("\(error.localizedDescription)")
        
        let alert = UIAlertController(
            title: "An error occured",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        if error.resolveCategory() != .fatal {
            alert.addAction(UIAlertAction(
                title: "Dismiss",
                style: .cancel
            ))
        }
        
        switch error.resolveCategory() {
        case .retryable:
            alert.addAction(UIAlertAction(
                title: "Retry",
                style: .default,
                handler: { _ in
                    retryHandler?()
                }
            ))
        case .nonRetryable:
            break
        case .fatal:
            alert.addAction(UIAlertAction(title: "Close SynthWorks", style: .destructive, handler: { _ in
                fatalError(error.localizedDescription)
            }))
        }
        
        alertContainingViewController.present(alert, animated: true)
    }
}
