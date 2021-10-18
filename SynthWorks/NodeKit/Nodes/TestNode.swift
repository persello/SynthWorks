//
//  TestNode.swift
//  TestNode
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

public class TestNode: NSObject, NKNode {
    required public init(id: UUID = UUID(), position: NKCoordinate, size: NKCoordinate) {
        self.id = id
        self.position = position
        self.size = size
    }

    public var id: UUID
    public var position: NKCoordinate
    public var size: NKCoordinate
    
    public override var description: String {
        "Test Node"
    }

    public func render(withUnitSize unit: CGFloat) -> UIView {
        let view = NKNodeView(from: self, unitSize: unit/*, withDelegate: self*/)
        view.backgroundColor = .red
        
        return view
    }
}

// MARK: - Node view delegate

//extension TestNode: NKNodeViewDelegate {
//
//}

// MARK: - NSItemProvider Protocols

extension TestNode: NSItemProviderReading {
    public static var readableTypeIdentifiersForItemProvider: [String] {
        return [Self.nodeUTI]
    }
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        return try JSONDecoder().decode(self, from: data)
    }
}

extension TestNode: NSItemProviderWriting {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [Self.nodeUTI]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let json = try JSONEncoder().encode(self)
            completionHandler(json, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return .none
    }
}
