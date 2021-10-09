//
//  TestNode.swift
//  TestNode
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

public class TestNode: NKNode {
    required public init(id: UUID = UUID(), position: NKCoordinate, size: NKCoordinate) {
        self.id = id
        self.position = position
        self.size = size
    }

    public var id: UUID
    public var position: NKCoordinate
    public var size: NKCoordinate
    public var description: String = "Test Node"

    public func render(withUnitSize unit: CGFloat) -> UIView {
        let view = NKNodeView(from: self, unitSize: unit, withDelegate: self)
        view.backgroundColor = .red
        
        return view
    }
}

extension TestNode: NKNodeViewDelegate {
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
