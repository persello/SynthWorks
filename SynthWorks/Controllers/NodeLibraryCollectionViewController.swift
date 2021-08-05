//
//  NodeLibraryCollectionViewController.swift
//  NodeLibraryCollectionViewController
//
//  Created by Riccardo Persello on 04/08/21.
//

import UIKit

class NodeLibraryCollectionViewController: UICollectionViewController {
 
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NodeList.allNodes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NodeCell", for: indexPath) as! NodeCell
        
        cell.configure(name: String(describing: NodeList.allNodes[index].self),
                       node: NodeList.allNodes[index].init(id: UUID(),
                                                           position: .zero,
                                                           size: NKCoordinate(x: 4, y: 4)))
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
}
