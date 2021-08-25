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
    public var delegate: NKNodeViewDelegate?

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(from node: NKNode,
                            unitSize unit: CGFloat,
                            withDelegate delegate: NKNodeViewDelegate? = nil) {
        let position = node.position
        let size = node.size

        self.init(frame: CGRect(x: unit * CGFloat(position.x),
                                y: unit * CGFloat(position.y),
                                width: unit * CGFloat(size.x),
                                height: unit * CGFloat(size.y)))

        unitSize = unit
        self.node = node
        self.delegate = delegate

        // MARK: Move interaction

        if superview is NKGrid {
            let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveGestureAction))
            addGestureRecognizer(moveGestureRecognizer)
        }
    }

    // MARK: - Private functions

    private func repositionBasedOnNodeCoordinates(animated: Bool) {
        func reposition(coordinate: NKCoordinate, unitSize: CGFloat) {
            frame.origin.x = CGFloat(coordinate.x) * unitSize
            frame.origin.y = CGFloat(coordinate.y) * unitSize
        }

        guard let node = node,
              let unitSize = unitSize else {
            return
        }

        if animated {
            UIView.animate(withDuration: 0.3) {
                reposition(coordinate: node.position, unitSize: unitSize)
            }
        } else {
            reposition(coordinate: node.position, unitSize: unitSize)
        }
    }

    @objc
    private func moveGestureAction(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            delegate?.dragStarted(for: self, from: node.position)
            dragStartCoordinates = node.position
            oldTouchLocation = sender.location(in: superview)

        case .changed:
            let currentTouchLocation = sender.location(in: superview)
            center += currentTouchLocation - oldTouchLocation
            oldTouchLocation = currentTouchLocation

        case .ended,
             .failed,
             .cancelled:
            delegate?.dragEnded(for: self, from: dragStartCoordinates, to: node.position)
            dragStartCoordinates = .zero
            oldTouchLocation = .zero

            let finalCoordinate = NKCoordinate(x: Int((frame.minX / unitSize).rounded()),
                                               y: Int((frame.minY / unitSize).rounded()))

            node.position = finalCoordinate

            repositionBasedOnNodeCoordinates(animated: true)

        default:
            break
        }
    }
}
