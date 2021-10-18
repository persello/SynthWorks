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
    private var nodes: [NKNode] = []

    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }
    
    // MARK: - Private functions

    private func configure() {
        clipsToBounds = true
        minimumZoomScale = 0.25
        maximumZoomScale = 4.0
        scrollsToTop = false

        delegate = self
        
        self.addInteraction(UIDropInteraction(delegate: self))

        addSubview(backgroundGrid)
    }
    
    private func realToIntegerCoordinates(_ inputCoordinate: CGPoint) -> NKCoordinate {
        let offsetInputCoordinate = inputCoordinate + self.contentOffset
        let x: Int = Int((offsetInputCoordinate.x / backgroundGrid.gridSpacing * self.contentScaleFactor))
        let y: Int = Int((offsetInputCoordinate.y / backgroundGrid.gridSpacing * self.contentScaleFactor))
        return NKCoordinate(x: x, y: y)
    }
    
    // MARK: - Public functions
    
    public func add(node: NKNode, position: NKCoordinate = .zero) {
        node.position = position
        nodes.append(node)
        
        let view = node.render(withUnitSize: backgroundGrid.gridSpacing)
        backgroundGrid.addSubview(view)
        backgroundGrid.bringSubviewToFront(view)
    }
}

extension NKView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundGrid
    }
}

extension NKView: UIDropInteractionDelegate {
    
    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: ["sy.node"])
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let location: CGPoint = session.location(in: self)
        session.loadObjects(ofClass: GenericNode.self) { nodes in
            if let nodes = nodes as? [GenericNode] {
                let dropCoordinate = self.realToIntegerCoordinates(location)
                nodes.forEach({
                    let centeredCoordinate = NKCoordinate(
                        x: dropCoordinate.x - $0.size.x/2,
                        y: dropCoordinate.y + $0.size.y/2
                    )
                    self.add(node: $0, position: centeredCoordinate)
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
