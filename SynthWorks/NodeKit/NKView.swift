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

        addSubview(backgroundGrid)
    }
    
    // MARK: - Public functions
    
    public func add(node: NKNode) {
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

extension NKView {
    override public func didMoveToSuperview() {
        configure()
    }
}
