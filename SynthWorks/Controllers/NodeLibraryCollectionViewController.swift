//
//  NodeLibraryCollectionViewController.swift
//  NodeLibraryCollectionViewController
//
//  Created by Riccardo Persello on 04/08/21.
//

import UIKit

class NodeLibraryCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dragDelegate = self
    }
    
    /// Returns the correct node for the specified `indexPath`.
    /// - Parameter indexPath: The index path given by the collection view.
    /// - Returns: The corresponding `NKNode` from the list of all the available nodes.
    private func getNode(for indexPath: IndexPath) -> NKNode {
        return NodeList.allNodes[indexPath.item].init(id: UUID(), position: .zero, size: NKCoordinate(x: 4, y: 4))
    }
    
    
    /// A function that can be passed to the cell configuration in order to dismiss the modal when the drag starts,
    private func hideModal() {
        dismiss(animated: true, completion: {})
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NodeList.allNodes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NodeCell", for: indexPath) as! NodeCell
        
        let node: NKNode = getNode(for: indexPath)
        
        cell.configure(node: node,
                       modalVisibility: hideModal)
        
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
}

extension NodeLibraryCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let cell = collectionView.cellForItem(at: indexPath)! as! NodeCell
        guard let node = cell.connectedNode else {
            return []
        }
        
        let nodeView = cell.nodeView.subviews.first ?? cell
        let provider = NSItemProvider(object: node)
        provider.suggestedName = node.description
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = node
        dragItem.previewProvider = {
            return UIDragPreview(view: nodeView)
        }
        return [dragItem]
    }
    
    // It makes no sense to drag a node to another app.
    func collectionView(_ collectionView: UICollectionView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
}
