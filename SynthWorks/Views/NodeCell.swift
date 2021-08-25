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
    
    func configure(name: String, node: NKNode) {
        nodeNameLabel.text = name
        
        let innerView: UIView!
        
        if renderedNode?.id != node.id {
            for view in nodeView.subviews { view.removeFromSuperview() }
            innerView = node.render(withUnitSize: 25)
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
