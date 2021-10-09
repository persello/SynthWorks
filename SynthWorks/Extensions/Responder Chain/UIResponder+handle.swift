//
//  UIResponder+handle.swift
//  UIResponder+handle
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

extension UIResponder {
    @objc
    func handle(_ error: Error,
                from viewController: UIViewController,
                retryHandler: (() -> Void)?) {
        
        // Try to pass the error down the responder chain.
        guard let nextResponder = next else {
            return assertionFailure("Unhandled error \(error) from \(viewController).")
        }

        nextResponder.handle(error,
                             from: viewController,
                             retryHandler: retryHandler
        )
    }
}
