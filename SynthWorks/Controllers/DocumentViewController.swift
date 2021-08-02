//
//  DocumentViewController.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import UIKit

class DocumentViewController: UIViewController {
    var document: Document?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Access the document
        document?.open(completionHandler: { success in
            if success {
                // Display the content of the document, e.g.:
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }

    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
