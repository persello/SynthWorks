//
//  GenericNode.swift
//  GenericNode
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

class GenericNode: NKNode {
    
    required init(id: UUID = UUID(), position: NKCoordinate, size: NKCoordinate) {
        self.id = id
        self.position = position
        self.size = size
    }
    
    var id: UUID
    var position: NKCoordinate
    var size: NKCoordinate
    
    private weak var renderCache: UIView?
    
    func render(withUnitSize unit: CGFloat) -> UIView {
        if let renderCache = renderCache {
            return renderCache
        }
        
        let view = NKNodeView(from: self, unitSize: unit, withDelegate: self)
        
        view.backgroundColor = .systemGray4
        
        view.layer.cornerRadius = unit
        view.layer.cornerCurve = .continuous
        
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = view.window?.screen.scale ?? UIScreen.main.scale
                
        renderCache = view
        
        return view
    }
    
    // Exclude render cache
    enum CodingKeys: String, CodingKey {
        case id
        case position
        case size
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
