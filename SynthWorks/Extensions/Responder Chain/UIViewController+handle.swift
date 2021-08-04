//
//  UIViewController+handle.swift
//  UIViewController+handle
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

extension UIViewController {
    func handle(_ error: Error,
                retryHandler: (() -> Void)?) {
        handle(error, from: self, retryHandler: retryHandler)
    }
}
