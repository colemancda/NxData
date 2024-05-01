//
//  Header.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

/// NX File Header
public struct FileHeader: Equatable, Hashable, Codable, Sendable {
    
    public static var length: Int { 52 }
    
    /// File Magic Header
    public static var magic: Data { Data([0x50, 0x4B, 0x47, 0x34]) }
    
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
    
    init?(data: Data) {
        guard data.count == Self.length else {
            return nil
        }
        let magic = data.subdataNoCopy(in: 0 ..< 4)
        guard magic == Self.magic else {
            return nil
        }
        self.nodeCount = UInt32(littleEndian: UInt32(bytes: (data[4], data[5], data[6], data[7])))
        self.nodeBlockOffset = UInt64(littleEndian: UInt64(bytes: (data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15])))
        self.stringCount = UInt32(littleEndian: UInt32(bytes: (data[16], data[17], data[18], data[19])))
        self.stringOffsetTableOffset = UInt64(littleEndian: UInt64(bytes: (data[20], data[21], data[22], data[23], data[24], data[25], data[26], data[27])))
        self.bitmapCount = UInt32(littleEndian: UInt32(bytes: (data[28], data[29], data[30], data[31])))
        self.bitmapOffsetTableOffset = UInt64(littleEndian: UInt64(bytes: (data[32], data[33], data[34], data[35], data[36], data[37], data[38], data[39])))
        self.audioCount = UInt32(littleEndian: UInt32(bytes: (data[40], data[41], data[42], data[43])))
        self.audioOffsetTableOffset = UInt64(littleEndian: UInt64(bytes: (data[44], data[45], data[46], data[47], data[48], data[49], data[50], data[51])))
    }
    
    init(path: String) throws {
        let data = try Data(
            contentsOf: URL(fileURLWithPath: path),
            options: [.alwaysMapped]
        )
        .prefix(FileHeader.length)
        guard let value = FileHeader(data: data) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = value
    }
}
