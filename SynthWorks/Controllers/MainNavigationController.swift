//
//  MainNavigationController.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    /// The current, opened workspace.
    var document: Document?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Access the document
        document?.open(completionHandler: { success in
            if success {
                // Display the content of the document.
                let document = self.document!

                let mvc = self.viewControllers.first as! MainViewController
                mvc.configure(withDocument: document,
                              returnToFileBrowserAction: self.dismissNavigationController)
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
                self.handle(DocumentError.openingFailure, retryHandler: nil)
                self.dismissNavigationController()
            }
        })
    }

    /// Go back to the document browser.
    func dismissNavigationController() {
        dismiss(animated: true) {
            
            // Set the current view controller back to document browser for displaying "unowned" alerts.
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.currentViewController = delegate.window?.rootViewController as! DocumentBrowserViewController
            
            self.document?.close(completionHandler: nil)
        }
    }
}
