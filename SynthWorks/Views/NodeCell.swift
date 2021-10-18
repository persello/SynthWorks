//
//  NodeCell.swift
//  NodeCell
//
//  Created by Riccardo Persello on 05/08/21.
//

import UIKit

class NodeCell: UICollectionViewCell {
    typealias ModalVisibilityControllerFunction = (() -> Void)
    @IBOutlet var nodeNameLabel: UILabel!
    @IBOutlet var nodeView: UIView!
    @IBOutlet var nodeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var nodeViewHeightConstraint: NSLayoutConstraint!
    
    private var controlModalVisibility: ModalVisibilityControllerFunction?
    private var renderedNode: NKNode? = nil
    weak var connectedNode: NKNode?
    
    override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {
        if dragState == .dragging {
            controlModalVisibility?()
        }
    }
    
    
    /// Configures the current cell in order to show the specified node.
    /// - Parameters:
    ///   - node: The selected node.
    ///   - modalVisibility: A function to control the library modal visibility. Used to hide the modal on drag start.
    func configure(node: NKNode, modalVisibility: ModalVisibilityControllerFunction? = nil) {
        nodeNameLabel.text = node.description.uppercased()
        controlModalVisibility = modalVisibility
        connectedNode = node
        
        let innerView: UIView!
        
        if renderedNode?.id != node.id {
            for view in nodeView.subviews { view.removeFromSuperview() }
            innerView = node.render(withUnitSize: 30)
            nodeView.addSubview(innerView)
            renderedNode = node
        } else {
            innerView = nodeView.subviews.first
        }
        
        // Adapt container to node render
        nodeViewWidthConstraint.constant = innerView.frame.width
        nodeViewHeightConstraint.constant = innerView.frame.height
    }
}
