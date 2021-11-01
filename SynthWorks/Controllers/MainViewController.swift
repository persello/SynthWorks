//
//  MainViewController.swift
//  MainViewController
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainCanvas: NKView!

    typealias ReturnToFileBrowserAction = () -> Void

    private var document: Document!
    private var workspace: Workspace!
    private var returnToFileBrowserAction: ReturnToFileBrowserAction? = nil


    /// Configures the Main view controller.
    /// - Parameters:
    ///   - document: The opened workspace.
    ///   - action: The action to execute when tapping the document icon.
    func configure(withDocument document: Document, returnToFileBrowserAction action: ReturnToFileBrowserAction? = nil) {
        self.document = document
        self.returnToFileBrowserAction = action
        self.title = document.description

        do {
            workspace = try document.getWorkspace()
            mainCanvas.nodes = workspace.nodes
            mainCanvas.refresh()
        } catch {
            handle(error, retryHandler: nil)
        }

        mainCanvas.nkDelegate = self
    }

    @IBAction func documentBrowserButtonAction(_ sender: UIBarButtonItem) {
        returnToFileBrowserAction?()
    }
}

extension MainViewController: NKDelegate {
    func node(added node: NKNode, to location: NKCoordinate) {
        node.position = location
        workspace.nodes.append(node)
        document.undoManager.registerUndo(withTarget: self) { target in
            target.mainCanvas.remove(node: node)
        }
    }

    func node(moved node: NKNode, to destination: NKCoordinate) {
        let oldPosition = node.position
        workspace.nodes.first(where: {$0.id == node.id})?.position = destination
        document.undoManager.registerUndo(withTarget: self) { target in
            target.mainCanvas.move(node: node, newPosition: oldPosition)
        }
    }

    func node(removed node: NKNode) {
        workspace.nodes.removeAll(where: { $0.id == node.id })
        document.undoManager.registerUndo(withTarget: self, handler: {target in
            target.mainCanvas.add(node: node)
        })
    }
}
