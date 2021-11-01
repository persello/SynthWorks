//
//  NKDelegate.swift
//  NKDelegate
//
//  Created by Riccardo Persello on 02/08/21.
//

import Foundation

public protocol NKDelegate {
    /// Called when a node is added to the canvas.
    /// - Parameters:
    ///   - node: The added node.
    ///   - location: The integer drop location.
    func node(added node: NKNode, to location: NKCoordinate)
    
    /// Called when a node is moved on the canvas.
    /// - Parameters:
    ///   - node: The moved node.
    ///   - destination: The integer drop location.
    func node(moved node: NKNode, to destination: NKCoordinate)
    
    /// Called when a node is removed from the canvas.
    /// - Parameters:
    ///   - node: The removed node
    func node(removed node: NKNode)
}
