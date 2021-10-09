//
//  NKNode.swift
//  NKNode
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

public protocol NKNode: Codable, CustomStringConvertible {
    
    init(id: UUID, position: NKCoordinate, size: NKCoordinate)
    
    var id: UUID { get }
    var position: NKCoordinate { get set }
    var size: NKCoordinate { get }

    func render(withUnitSize unit: CGFloat) -> UIView
}

extension NKNode {
    var description: String {
        "Node"
    }
}
