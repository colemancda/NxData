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
public struct Node: Equatable, Hashable, Codable, Identifiable, Sendable {
    
    public static var length: Int { 20 }
    
    public let id: ID
    
    public var firstChild: Node.ID
    
    public var childrenCount: UInt16
    
    public var data: NodeData
}
