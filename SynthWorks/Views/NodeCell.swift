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
    
    weak var renderedNode: NKNode? = nil
    
    /// A function to control the visibility of the library modal.
    private var modalVisibility: ((Bool) -> Void)?
    
    /// Configures the current cell in order to show the specified node.
    /// - Parameters:
    ///   - node: The selected node.
    ///   - modalVisibility: A function to control the library modal visibility. Used to hide the modal on drag start.
    func configure(node: NKNode, modalVisibility: @escaping (Bool) -> Void) {
        self.nodeNameLabel.text = node.description.uppercased()
        self.modalVisibility = modalVisibility
        
        let innerView: NKNodeView!
        
        if renderedNode?.id != node.id {
            for view in nodeView.subviews { view.removeFromSuperview() }
            innerView = node.render(withUnitSize: 30)
            innerView.delegate = self
            nodeView.addSubview(innerView)
            renderedNode = node
        } else {
            innerView = nodeView.subviews.first as? NKNodeView
        }
        
        // Adapt container to node render
        self.nodeViewWidthConstraint.constant = innerView.frame.width
        self.nodeViewHeightConstraint.constant = innerView.frame.height
        
        // Tap animation
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateTap)))
    }
    
    /// Displays a short, jumping animation on the node when tapped, to suggest the user to drag it on the canvas.
    @objc private func animateTap() {
        let animation = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
        animation.valueFunction = CAValueFunction(name: CAValueFunctionName.translateY)
        animation.fromValue = 0
        animation.toValue = -25
        animation.duration = 0.15
        animation.autoreverses = true
        animation.stiffness = 0
        
        // Target the actual node
        nodeView.subviews.first?.layer.add(animation, forKey: nil)
    }
}

extension NodeCell: NKNodeViewDelegate {
    func nodeView(_ node: NKNode, isBeingDraggedIntoCanvas: Bool) {
        self.modalVisibility?(!isBeingDraggedIntoCanvas)
    }
}
