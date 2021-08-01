//
//  DocumentBrowserViewController.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import os
import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController {
    private var logger = Logger(category: "DocumentBrowserViewController")
    private var transitionController: UIDocumentBrowserTransitionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        localizedCreateDocumentActionTitle = "Create Workspace"
    }
}

extension DocumentBrowserViewController: UIViewControllerTransitioningDelegate {
    
    // Same transition controller for both presentation and dismissal.
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
}

extension DocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        logger.info("Document creation requested.")

        // Create a new workspace and it to a file.
        let newWorkspace = Workspace()

        // Create the document in a temporary folder.
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Untitled.syworkspace")
        let newDocument = Document(fileURL: tempURL)
        newDocument.workspace = newWorkspace

        logger.info("Created a temporary document at \"\(newDocument.fileURL)\".")

        // Save the document to the temporary folder, then call the handler.
        newDocument.save(to: tempURL, for: .forCreating, completionHandler: { successful in
            if successful {
                importHandler(tempURL, .move)
                self.logger.info("File saved successfully: called import handler for \"\(newDocument)\".")
            } else {
                importHandler(nil, .none)
                self.logger.warning("Error while saving temporary file. Import handler was called with nil.")
            }
        })
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }

        presentDocument(at: sourceURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        logger.error("Document import for \"\(documentURL.absoluteString)\" failed: \"\(error?.localizedDescription ?? "Unknown error")\".")

        let alert = UIAlertController(title: "An error occurred", message: "During the creation or import of this workspace, the following error occurred: \"\(error?.localizedDescription ?? "Unknown error")\".", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: { _ in }))
        present(alert, animated: true)
    }

    // MARK: Document Presentation

    func presentDocument(at documentURL: URL) {
        logger.info("Presenting document at URL \"\(documentURL)\".")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        
        documentViewController.document = Document(fileURL: documentURL)
        documentViewController.modalPresentationStyle = .fullScreen
        
        // Assign the transition delegate and get the appropriate transition controller.
        documentViewController.transitioningDelegate = self
        self.transitionController = transitionController(forDocumentAt: documentURL)

        present(documentViewController, animated: true, completion: nil)
    }
}
