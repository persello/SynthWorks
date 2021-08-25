//
//  NodeList.swift
//  NodeList
//
//  Created by Riccardo Persello on 04/08/21.
//

import Foundation

struct NodeList {
    static let allNodes: [NKNode.Type] =  Array.init(repeating: GenericNode.self, count: 100)
}
