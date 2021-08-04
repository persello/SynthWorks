//
//  MainViewController.swift
//  MainViewController
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

class MainViewController: UIViewController {
    typealias ReturnToFileBrowserAction = () -> Void
    
    var returnToFileBrowserAction: ReturnToFileBrowserAction? = nil
    private var document: Document!
    
    func configure(withDocument document: Document, returnToFileBrowserAction action: ReturnToFileBrowserAction? = nil) {
        self.document = document
        self.returnToFileBrowserAction = action
        
        title = document.description
    }
    
    @IBAction func documentBrowserButtonAction(_ sender: UIBarButtonItem) {
        
        returnToFileBrowserAction?()
    }
}
