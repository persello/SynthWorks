//
//  NKView.swift
//  NKView
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

@IBDesignable
/// The main view for this library: implements an interactive node graph editor.
public class NKView: UIScrollView {
    private let backgroundGrid: NKGrid! = NKGrid(frame: CGRect(x: 0, y: 0, width: 5000, height: 5000))
    public var nodes: [NKNode] = []

    public var nkDelegate: NKDelegate?

    // MARK: - Initializers

    /// Creates a new `NKView` with the specified frame.
    /// - Parameter frame: A `CGRect` used for creating the new canvas.
    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configure()
    }

    // MARK: - Private functions

    /// Configures the view properties, including the scrollview zooming behaviour, delegate, interactions.
    /// It adds the background grid to the scroll view.
    private func configure() {
        self.clipsToBounds = true
        self.minimumZoomScale = 0.25
        self.maximumZoomScale = 4.0
        self.scrollsToTop = false
        self.bouncesZoom = true
        self.bounces = true

        self.delegate = self

        self.addInteraction(UIDropInteraction(delegate: self))

        // Otherwise it won't scroll until zoomed.
        self.contentSize = backgroundGrid.frame.size

        self.addSubview(backgroundGrid)
    }

    /// Rounds a real `CGPoint` down to an integer `NKCoordinate`.
    /// - Parameter inputCoordinate: The `CGPoint` to convert.
    /// - Returns: The rounded, integer `NKCoordinate`.
    private func realToIntegerCoordinates(_ inputCoordinate: CGPoint) -> NKCoordinate {
        let offsetInputCoordinate = inputCoordinate
        let x: Int = Int((offsetInputCoordinate.x / backgroundGrid.gridSpacing * self.contentScaleFactor))
        let y: Int = Int((offsetInputCoordinate.y / backgroundGrid.gridSpacing * self.contentScaleFactor))
        return NKCoordinate(x: x, y: y)
    }

    // MARK: - Public functions

    public func refresh() {
        backgroundGrid.subviews.forEach({ $0.removeFromSuperview() })

        for node in nodes {
            let view = node.render(withUnitSize: backgroundGrid.gridSpacing)
            view.tag = node.id.hashValue
            backgroundGrid.addSubview(view)
            backgroundGrid.bringSubviewToFront(view)
        }
    }

    /// Adds a node to the view.
    /// - Parameters:
    ///   - node: The node object to be added to the view.
    ///   - position: The integer position for the new node. Defaults to zero.
    public func add(node: NKNode, position: NKCoordinate = .zero) {
        node.position = position
        self.nodes.append(node)

        let view = node.render(withUnitSize: backgroundGrid.gridSpacing)
        view.tag = node.id.hashValue
        backgroundGrid.addSubview(view)
        backgroundGrid.bringSubviewToFront(view)

        nkDelegate?.node(added: node, to: position)
    }

    /// Removes the specified node from the view.
    /// - Parameter node: The node to be removed.
    public func remove(node: NKNode) {
        nodes.removeAll(where: { $0 == node })
        backgroundGrid.viewWithTag(node.id.hashValue)?.removeFromSuperview()
        nkDelegate?.node(removed: node)
    }

    /// Moves a node.
    /// - Parameters:
    ///   - node: The node to be moved.
    ///   - newPosition: The new coordinate for the node.
    public func move(node: NKNode, newPosition: NKCoordinate) {
        // Find the node
        guard let index = self.nodes.firstIndex(where: { $0 == node }) else {
            return
        }

        // Change position and re-render
        nodes[index].position = newPosition
        backgroundGrid.viewWithTag(nodes[index].id.hashValue)?.removeFromSuperview()
        nodes[index].invalidateRenderCache()
        let view = nodes[index].render(withUnitSize: backgroundGrid.gridSpacing)
        view.tag = nodes[index].id.hashValue
        backgroundGrid.addSubview(view)
        backgroundGrid.bringSubviewToFront(view)
        nkDelegate?.node(moved: node, to: newPosition)

    }
}

extension NKView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundGrid
    }
}

extension NKView: UIDropInteractionDelegate {

    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: ["nk.node"])
    }

    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {

        for item in session.items {
            if let node = item.localObject as? NKNode {
                if self.nodes.contains(where: { $0 == node }) {
                    return UIDropProposal(operation: .move)
                }
            }
        }

        return UIDropProposal(operation: .copy)
    }

    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let location: CGPoint = session.location(in: self)
        session.loadObjects(ofClass: GenericNode.self) { nodes in
            if let nodes = nodes as? [NKNode] {
                let dropCoordinate = self.realToIntegerCoordinates(location)
                nodes.forEach({ node in
                    let centeredCoordinate = dropCoordinate - node.size / 2

                    if self.nodes.contains(where: { $0 == node }) {
                        self.move(node: node, newPosition: centeredCoordinate)
                    } else {
                        self.add(node: node, position: centeredCoordinate)
                    }
                })
            }
        }
    }
}

extension NKView {
    override public func didMoveToSuperview() {
        configure()
    }
}
