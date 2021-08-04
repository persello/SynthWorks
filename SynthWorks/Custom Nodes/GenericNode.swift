//
//  GenericNode.swift
//  GenericNode
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

class GenericNode: NKNode {
    var id: UUID
    
    var position: NKCoordinate
    
    var size: NKCoordinate
    
    func render(withUnitSize unit: CGFloat) -> UIView {
        let view = NKNodeView(from: self, unitSize: unit, withDelegate: self)
        
        view.backgroundColor = .systemGray4
        
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        
        return view
    }
}

extension GenericNode: NKNodeViewDelegate {
    public func dragStarted(for node: NKNodeView, from startCoordinate: NKCoordinate) {
        UIView.animate(withDuration: 0.3) {
            node.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    public func dragEnded(for node: NKNodeView, from startCoordinate: NKCoordinate, to endCoordinate: NKCoordinate) {
        UIView.animate(withDuration: 0.3) {
            node.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
