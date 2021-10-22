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

    public var controlModal: ((Bool) -> Void)?
    
    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(from node: NKNode,
                            unitSize unit: CGFloat) {
        let position = node.position
        let size = node.size

        self.init(frame: CGRect(x: unit * CGFloat(position.x),
                                y: unit * CGFloat(position.y),
                                width: unit * CGFloat(size.x),
                                height: unit * CGFloat(size.y)))

        unitSize = unit
        self.node = node
        self.addInteraction(UIDragInteraction(delegate: self))
    }
}

// MARK: - Drag Interaction Delegate

extension NKNodeView: UIDragInteractionDelegate {
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let node = self.node else {
            return []
        }
        
        let provider = NSItemProvider(object: node)
        provider.suggestedName = node.description
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = node
        dragItem.previewProvider = {
            return UIDragPreview(view: self)
        }
        return [dragItem]
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        controlModal?(false)
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        if operation == .copy {
            controlModal?(true)
        }
    }
}
