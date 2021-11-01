//
//  Workspace.swift
//  Workspace
//
//  Created by Riccardo Persello on 01/08/21.
//

import Foundation

class Workspace: NSObject, Codable {
    var version: Int? = 1
    var nodes: [NKNode] = []

    struct TypedNode: Codable {
        let node: GenericNode
        var type: String {
            return String(describing: Swift.type(of: node))
        }

        enum CodingKeys: String, CodingKey {
            case node
            case type
        }

        init(from node: GenericNode) {
            self.node = node
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let metatype: String = try container.decode(String.self, forKey: .type)
            guard let type: GenericNode.Type = NodeList.getType(for: metatype) else {
                throw DecodingError.dataCorruptedError(forKey: CodingKeys.type,
                                                       in: container,
                                                       debugDescription: "The decoded metatype does not have any associated type (\(metatype)).")
            }

            node = try container.decode(type, forKey: .node)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(node, forKey: .node)
        }
    }


    enum CodingKeys: String, CodingKey {
        case version
        case nodes
    }

    override public init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(Int.self, forKey: .version)

        let typedNodes: [TypedNode] = try container.decode([TypedNode].self, forKey: .nodes)

        self.nodes = typedNodes.map({ $0.node })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)

        // TODO: Remove NKNode or GenericNode: they are the same thing.
        let typedNodes = nodes.map({ return TypedNode(from: $0 as! GenericNode) })

        try container.encode(typedNodes, forKey: .nodes)
    }
}
