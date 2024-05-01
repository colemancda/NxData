//
//  NodeView.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

public extension NxFile {
    
    subscript(index: Node.ID) -> Node {
        get async throws {
            let nodeOffset = try await header.nodeBlockOffset + (UInt64(index.rawValue) * UInt64(Node.length))
            var data = Data(repeating: 0x00, count: Node.length)
            let bytesRead = try data.withUnsafeMutableBytes { buffer in
                try handle.read(fromAbsoluteOffset: Int64(nodeOffset), into: buffer, retryOnInterrupt: true)
            }
            guard bytesRead == Node.length else {
                throw CocoaError(.fileReadCorruptFile)
            }
            guard let node = Node.init(data: data) else {
                throw CocoaError(.fileReadCorruptFile)
            }
            return node
        }
    }
}

// MARK: - AsyncSequence

extension NxFile: AsyncSequence {
    
    public typealias Index = Node.ID
    
    public typealias Element = Node
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        
        let file: NxFile
        
        var index: UInt32 = 0
        
        public mutating func next() async throws -> Node? {
            let count = try await file.header.nodeCount
            guard index < count else {
                return nil
            }
            let element = try await file[.init(rawValue: index)]
            index += 1
            return element
        }
    }
    
    public nonisolated func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(file: self)
    }
}
