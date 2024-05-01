//
//  OffsetTable.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation
import System

internal extension NxFile {
    
    /// Nx File Offset Table
    ///
    /// Sequential offset array; the first offset has ID 0, the second has ID 1, and so on.
    struct OffsetTable {
        
        let file: NxFile
        
        let offset: UInt64
        
        let count: UInt32
    }
}

extension NxFile.OffsetTable {
    
    subscript(index: UInt32) -> Element {
        get async throws {
            assert(index < count)
            let offset = self.offset + (UInt64(index) * 8)
            var element: UInt64 = 0
            let bytes = try await file.read(at: Int(offset), into: &element)
            guard bytes == 8 else {
                throw CocoaError(.fileReadUnknown)
            }
            assert(element != 0x00)
            return element
        }
    }
}

// MARK: - AsyncSequence

extension NxFile.OffsetTable: AsyncSequence {
    
    typealias Element = UInt64
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        let table: NxFile.OffsetTable
        
        var index: UInt32 = 0
        
        mutating func next() async throws -> NxFile.OffsetTable.Element? {
            guard index < table.count else {
                return nil
            }
            // fetch element
            let element = try await table[index]
            index += 1 // increment index
            return element
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(table: self)
    }
}
