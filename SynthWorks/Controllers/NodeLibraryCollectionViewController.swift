//
//  NodeLibraryCollectionViewController.swift
//  NodeLibraryCollectionViewController
//
//  Created by Riccardo Persello on 04/08/21.
//

import UIKit

class NodeLibraryCollectionViewController: UICollectionViewController {
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Returns the correct node for the specified `indexPath`.
    /// - Parameter indexPath: The index path given by the collection view.
    /// - Returns: The corresponding `NKNode` from the list of all the available nodes.
    private func getNode(for indexPath: IndexPath) -> NKNode {
        return NodeList.allNodes[indexPath.item].init(id: UUID(), position: .zero, size: NKCoordinate(x: 4, y: 4))
    }
    
    
    /// A function that can be passed to the cell configuration in order to dismiss the modal when the drag starts,
    private func controlModal(visible: Bool) {
        if !visible && !isBeingDismissed {
            dismiss(animated: true, completion: nil)
        } else if visible {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if let controller = delegate.currentViewController as? MainNavigationController {
                    controller.present(StoryboardScene.Main.nodeLibraryNavigationController.instantiate(), animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NodeList.allNodes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NodeCell", for: indexPath) as! NodeCell
        
        let node: NKNode = getNode(for: indexPath)
        
        cell.configure(node: node, modalVisibility: controlModal)
        
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
}
