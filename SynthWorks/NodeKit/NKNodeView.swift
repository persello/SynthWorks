//
//  NKNodeView.swift
//  NKNodeView
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

public class NKNodeView: UIView {
    private var node: NKNode!
    private var unitSize: CGFloat!
    private var oldTouchLocation: CGPoint = .zero
    private var dragStartCoordinates: NKCoordinate = .zero
//    public var delegate: NKNodeViewDelegate?

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(from node: NKNode,
                            unitSize unit: CGFloat//,
                            /* withDelegate delegate: NKNodeViewDelegate? = nil*/) {
        let position = node.position
        let size = node.size

        self.init(frame: CGRect(x: unit * CGFloat(position.x),
                                y: unit * CGFloat(position.y),
                                width: unit * CGFloat(size.x),
                                height: unit * CGFloat(size.y)))

        unitSize = unit
        self.node = node
//        self.delegate = delegate
    }
}
