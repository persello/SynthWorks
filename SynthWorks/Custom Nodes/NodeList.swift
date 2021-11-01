//
//  NodeList.swift
//  NodeList
//
//  Created by Riccardo Persello on 04/08/21.
//

import Foundation

struct NodeList {
    static let allNodes: [GenericNode.Type] = Array.init(repeating: GenericNode.self, count: 100)
    
    static func getType(for key: String) -> GenericNode.Type? {
        for type in allNodes {
            if String(describing: type) == key {
                return type
            }
        }
        
        return nil
    }
}
