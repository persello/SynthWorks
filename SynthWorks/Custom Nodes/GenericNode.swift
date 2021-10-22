//
//  GenericNode.swift
//  GenericNode
//
//  Created by Riccardo Persello on 03/08/21.
//

import UIKit

class GenericNode: NSObject, NKNode {
    
    required init(id: UUID = UUID(), position: NKCoordinate, size: NKCoordinate) {
        self.id = id
        self.position = position
        self.size = size
    }
    
    var id: UUID
    var position: NKCoordinate
    var size: NKCoordinate
    override var description: String {
        "Generic Node"
    }
    
    private weak var renderCache: NKNodeView?
    
    func render(withUnitSize unit: CGFloat) -> NKNodeView {
        if let renderCache = renderCache {
            return renderCache
        }
        
        let view = NKNodeView(from: self, unitSize: unit)
        
        view.backgroundColor = .systemGray4
        
        view.layer.cornerRadius = unit / 2
        view.layer.cornerCurve = .continuous
        
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowPath = CGPath(roundedRect: CGRect(origin: .zero, size: view.frame.size), cornerWidth: unit/2, cornerHeight: unit/2, transform: .none)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = view.window?.screen.scale ?? UIScreen.main.scale
                
        renderCache = view
        
        return view
    }
    
    // Exclude render cache
    enum CodingKeys: String, CodingKey {
        case id
        case position
        case size
    }
}

// MARK: - Node view delegate

//extension GenericNode: NKNodeViewDelegate {
//
//}

// MARK: - NSItemProvider Protocols

extension GenericNode: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [Self.nodeUTI]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        return try JSONDecoder().decode(self, from: data)
    }
}

extension GenericNode: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [Self.nodeUTI]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let json = try JSONEncoder().encode(self)
            completionHandler(json, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return .none
    }
}
