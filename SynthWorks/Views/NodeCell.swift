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
    
    func configure(name: String, node: NKNode) {
        nodeNameLabel.text = name
        
        let innerView = node.render(withUnitSize: 30)
        nodeView.addSubview(innerView)
        
        // Adapt container to node render
        nodeViewWidthConstraint.constant = innerView.frame.width
        nodeViewHeightConstraint.constant = innerView.frame.height
    }
}
