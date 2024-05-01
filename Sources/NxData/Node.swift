//
//  Node.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

/**
 Each Node is assigned a zero-based 32-bit unsigned ID in the order they appear in the node block; that is, the first Node (the base node) has ID 0, the second node has ID 1, and so on. This ID is used to point to child nodes of Nodes.

 All Nodes should be in one contiguous block, which should be of size 20 * Number of nodes. Nodes must be aligned to an 8-byte boundary.

 Children Nodes of each parent Node must be consecutive in one contiguous block, and the ID of the first child in the block is specified in the First Child ID field of the parent Node. Children Nodes of each parent Node must be sorted in ascending order according to the UTF-8 value of the node name of each child. Children Nodes of any given parent Node must have unique node names.

 The base node should have an ID of 0, and preferably have type 0 (None).
 */
public struct Node: Equatable, Hashable, Codable, Sendable {
    
    public static var length: Int { 20 }
    
    public let name: StringID
    
    public var firstChild: Node.ID?
    
    public var childrenCount: UInt16
    
    public var data: NodeData
    
    public init(
        name: StringID,
        firstChild: Node.ID? = nil,
        childrenCount: UInt16 = 0,
        data: NodeData = .none
    ) {
       self.name = name
       self.firstChild = firstChild
       self.childrenCount = childrenCount
       self.data = data
   }
}

public extension Node {
    
    init?(data: Data) {
        guard data.count == Self.length else {
            return nil
        }
        let name = StringID(rawValue: UInt32(littleEndian: UInt32(bytes: (data[0], data[1], data[2], data[3]))))
        let firstChild = Node.ID(rawValue: UInt32(littleEndian: UInt32(bytes: (data[4], data[5], data[6], data[7]))))
        let childrenCount = UInt16(littleEndian: UInt16(bytes: (data[8], data[9])))
        let rawNodeDataType = UInt16(littleEndian: UInt16(bytes: (data[10], data[11])))
        guard let dataType = NodeDataType(rawValue: rawNodeDataType) else {
            return nil
        }
        let nodeData = NodeData(unsafe: data.subdataNoCopy(in: 12 ..< 20), type: dataType)
        self.init(
            name: name,
            firstChild: childrenCount > 0 ? firstChild : nil,
            childrenCount: childrenCount,
            data: nodeData
        )
    }
}
