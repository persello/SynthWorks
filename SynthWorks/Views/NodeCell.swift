//
//  NodeCell.swift
//  NodeCell
//
//  Created by Riccardo Persello on 05/08/21.
//

import UIKit

class NodeCell: UICollectionViewCell {
    @IBOutlet var nodeNameLabel: UILabel!
    @IBOutlet var nodeView: UIView!
    @IBOutlet var nodeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var nodeViewHeightConstraint: NSLayoutConstraint!
    
    private var renderedNode: NKNode? = nil
    weak var connectedNode: NKNode?
    
    
    /// Configures the current cell in order to show the specified node.
    /// - Parameters:
    ///   - node: The selected node.
    ///   - modalVisibility: A function to control the library modal visibility. Used to hide the modal on drag start.
    func configure(node: NKNode, modalVisibility: @escaping (Bool) -> Void) {
        nodeNameLabel.text = node.description.uppercased()
        connectedNode = node
        
        let innerView: NKNodeView!
        
        if renderedNode?.id != node.id {
            for view in nodeView.subviews { view.removeFromSuperview() }
            innerView = node.render(withUnitSize: 30)
            innerView.controlModal = modalVisibility
            nodeView.addSubview(innerView)
            renderedNode = node
        } else {
            innerView = nodeView.subviews.first as? NKNodeView
        }
        
        // Adapt container to node render
        nodeViewWidthConstraint.constant = innerView.frame.width
        nodeViewHeightConstraint.constant = innerView.frame.height
    }
}
