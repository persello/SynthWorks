//
//  NKNodeViewDelegate.swift
//  NKNodeViewDelegate
//
//  Created by Riccardo Persello on 03/08/21.
//

import Foundation

public protocol NKNodeViewDelegate {
    
    /// This function is called whenever a node is being dragged for a copy operation into a canvas.
    /// - Parameters:
    ///   - node: The sender object for this action.
    ///   - isBeingDraggedIntoCanvas: `true` when the node is being dragged. Becomes `false` once it's dropped.
    func nodeView(_ node: NKNode, isBeingDraggedIntoCanvas: Bool)
}
