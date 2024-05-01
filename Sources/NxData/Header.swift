//
//  Header.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation
import System

/// NX File Header
public struct FileHeader: Equatable, Hashable, Codable, Sendable {
    
    public static var length: Int { 52 }
    
    /// File Magic Header
    public static var magic: UInt32 { UInt32(bigEndian: UInt32(bytes: (0x50, 0x4B, 0x47, 0x34))) }
    
    /// Total number of nodes in the file. Cannot be zero.
    public var nodeCount: UInt32
    
    /// Node block offset
    public var nodeBlockOffset: UInt64
    
    /// String count
    public var stringCount: UInt32
    
    /// String offset table offset
    public var stringOffsetTableOffset: UInt64
    
    /// Bitmap count
    public var bitmapCount: UInt32
    
    /// Bitmap offset table offset
    public var bitmapOffsetTableOffset: UInt64
    
    /// Audio count
    public var audioCount: UInt32
    
    /// Audio offset table offset
    public var audioOffsetTableOffset: UInt64
    
    public init(
        nodeCount: UInt32,
        nodeBlockOffset: UInt64,
        stringCount: UInt32,
        stringOffsetTableOffset: UInt64,
        bitmapCount: UInt32,
        bitmapOffsetTableOffset: UInt64,
        audioCount: UInt32,
        audioOffsetTableOffset: UInt64
    ) {
        self.nodeCount = nodeCount
        self.nodeBlockOffset = nodeBlockOffset
        self.stringCount = stringCount
        self.stringOffsetTableOffset = stringOffsetTableOffset
        self.bitmapCount = bitmapCount
        self.bitmapOffsetTableOffset = bitmapOffsetTableOffset
        self.audioCount = audioCount
        self.audioOffsetTableOffset = audioOffsetTableOffset
    }
}

public extension FileHeader {
    
    /// Initialize from bytes.
    init?(data: Data) {
        guard data.count == Self.length else {
            return nil
        }
        let magic = UInt32(bigEndian: UInt32(bytes: (data[0], data[1], data[2], data[3])))
        guard magic == Self.magic else {
            return nil
        }
        self.init(unsafe: data)
    }
    
    /// Initialize by reading at file path.
    init(path: String) throws {
        let filePath = FilePath(path)
        let handle = try FileDescriptor.open(filePath, .readOnly)
        try self.init(file: handle)
    }
}

internal extension FileHeader {
    
    /// Initialize from bytes without validation.
    init(unsafe data: Data) {
        self.nodeCount = UInt32(littleEndian: UInt32(bytes: (data[4], data[5], data[6], data[7])))
        self.nodeBlockOffset = UInt64(littleEndian: UInt64(bytes: (data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15])))
        self.stringCount = UInt32(littleEndian: UInt32(bytes: (data[16], data[17], data[18], data[19])))
        self.stringOffsetTableOffset = UInt64(littleEndian: UInt64(bytes: (data[20], data[21], data[22], data[23], data[24], data[25], data[26], data[27])))
        self.bitmapCount = UInt32(littleEndian: UInt32(bytes: (data[28], data[29], data[30], data[31])))
        self.bitmapOffsetTableOffset = UInt64(littleEndian: UInt64(bytes: (data[32], data[33], data[34], data[35], data[36], data[37], data[38], data[39])))
        self.audioCount = UInt32(littleEndian: UInt32(bytes: (data[40], data[41], data[42], data[43])))
        self.audioOffsetTableOffset = UInt64(littleEndian: UInt64(bytes: (data[44], data[45], data[46], data[47], data[48], data[49], data[50], data[51])))
    }
    
    /// Read using file handle.
    init(file: FileDescriptor) throws {
        var data = Data(repeating: 0x00, count: Self.length)
        let bytesRead = try data.withUnsafeMutableBytes { buffer in
            try file.read(fromAbsoluteOffset: 0, into: buffer, retryOnInterrupt: true)
        }
        guard bytesRead == Self.length else {
            throw CocoaError(.fileReadCorruptFile)
        }
        guard let value = Self.init(data: data) else {
            assertionFailure()
            throw CocoaError(.fileReadCorruptFile)
        }
        assert(value.nodeCount > 0)
        assert(value.nodeBlockOffset >= Self.length)
        self = value
    }
}
