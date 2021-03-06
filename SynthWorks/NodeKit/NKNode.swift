//
//  NKNode.swift
//  NKNode
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

public protocol NKNode: NSObject, NSItemProviderReading, NSItemProviderWriting, Codable {
    
    init(id: UUID, position: NKCoordinate, size: NKCoordinate)
    
    var id: UUID { get }
    var position: NKCoordinate { get set }
    var size: NKCoordinate { get }
        
    func render(withUnitSize unit: CGFloat) -> NKNodeView
    func invalidateRenderCache()
}

extension NKNode {
    static var nodeUTI: String {
        "nk.node"
    }
}
