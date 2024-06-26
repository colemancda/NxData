//
//  StringView.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

public extension NxFile {
    
    struct StringView {
        
        internal let file: NxFile
        
        internal init(file: NxFile) {
            self.file = file
        }
    }
}

public extension NxFile {
    
    /// Strings Async Sequence View
    nonisolated var string: StringView {
        StringView(file: self)
    }
}

internal extension NxFile {
    
    /// String offset table sequence
    var stringOffsetTable: OffsetTable {
        get async throws {
            try await OffsetTable(
                file: self,
                offset: header.stringOffsetTableOffset,
                count: header.stringCount
            )
        }
    }
}

public extension NxFile.StringView {
    
    var count: UInt32 {
        get async throws {
            try await file.header.stringCount
        }
    }
    
    subscript(index: StringID) -> String {
        get async throws {
            let offsetTable = try await file.stringOffsetTable
            let stringOffset = try await offsetTable[index.rawValue]
            var stringLength: UInt16 = 0
            var bytesRead = try await file.read(at: Int(stringOffset), into: &stringLength)
            guard bytesRead == 2 else {
                throw CocoaError(.fileReadCorruptFile)
            }
            guard stringLength > 0 else {
                return ""
            }
            let stringDataOffset = Int64(stringOffset + 2)
            let string = try await file.withFileHandle { handle in
                try String(unsafeUninitializedCapacity: Int(stringLength)) { buffer in
                    try handle.read(fromAbsoluteOffset: stringDataOffset, into: .init(buffer), retryOnInterrupt: true)
                }
            }
            bytesRead = string.utf8.count
            guard bytesRead == Int(stringLength) else {
                throw CocoaError(.fileReadCorruptFile)
            }
            assert(string.isEmpty == false)
            return string
        }
    }
}

// MARK: - AsyncSequence

extension NxFile.StringView: AsyncSequence {
    
    public typealias Index = StringID
    
    public typealias Element = String
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        
        let strings: NxFile.StringView
        
        var index: UInt32 = 0
        
        public mutating func next() async throws -> String? {
            let count = try await strings.count
            guard index < count else {
                return nil
            }
            let element = try await strings[.init(rawValue: index)]
            index += 1
            return element
        }
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(strings: self)
    }
}
