//
//  NodeData.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

/// Nx Node Data
public enum NodeData: Equatable, Hashable, Codable, Sendable {
    
    /// No data
    ///
    /// This field is ignored.
    case none
    
    /// 64-bit signed integer.
    case integer(Int32)
    
    /// 64-bit IEEE double-precision floating point.
    case double(Double)
    
    /// 32-bit unsigned string ID.
    case string(StringID)
    
    /// Two 32-bit signed integers (Int32), for X and Y respectively.
    case vector(Vector)
    
    /// 32-bit unsigned bitmap ID, followed by 16-bit unsigned width and height in that order. Ignored if Bitmap count in Header is 0.
    case bitmap(id: Bitmap.ID, length: UInt16)
    
    /// 32-bit unsigned audio ID, followed by 32-bit unsigned data length. Ignored if Audio count in Header is 0.
    case audio(id: Audio.ID, length: UInt32)
}

public extension NodeData {
    
    /// Node Data Type
    var type: NodeDataType {
        switch self {
        case .none:
            return .none
        case .integer:
            return .integer
        case .double:
            return .double
        case .string:
            return .string
        case .vector:
            return .vector
        case .bitmap:
            return .bitmap
        case .audio:
            return .audio
        }
    }
}

public extension NodeData {
    
    static var length: Int { 8 }
    
    init?(data: Data, type: NodeDataType) {
        guard data.count == Self.length else {
            return nil
        }
        self.init(unsafe: data, type: type)
    }
}

internal extension NodeData {
    
    init(unsafe data: Data, type: NodeDataType) {
        assert(data.count == Self.length)
        switch type {
        case .none:
            self = .none
        case .integer:
            let value = Int32(littleEndian: Int32(bytes: (data[0], data[1], data[2], data[3])))
            self = .integer(value)
        case .double:
            let value = UInt64(littleEndian: UInt64(bytes: (data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7])))
            self = .double(Double(bitPattern: value))
        case .string:
            let id = StringID(rawValue: UInt32(littleEndian: UInt32(bytes: (data[0], data[1], data[2], data[3]))))
            self = .string(id)
        case .vector:
            let x = Int32(littleEndian: Int32(bytes: (data[0], data[1], data[2], data[3])))
            let y = Int32(littleEndian: Int32(bytes: (data[4], data[5], data[6], data[7])))
            self = .vector(.init(x: x, y: y))
        case .bitmap:
            let id = Bitmap.ID(rawValue: UInt32(littleEndian: UInt32(bytes: (data[0], data[1], data[2], data[3]))))
            let length = UInt16(littleEndian: UInt16(bytes: (data[4], data[5])))
            self = .bitmap(id: id, length: length)
        case .audio:
            let id = Audio.ID(rawValue: UInt32(littleEndian: UInt32(bytes: (data[0], data[1], data[2], data[3]))))
            let length = UInt32(littleEndian: UInt32(bytes: (data[4], data[5], data[6], data[7])))
            self = .audio(id: id, length: length)
        }
    }
}

// MARK: - ExpressibleByNilLiteral

extension NodeData: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self = .none
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension NodeData: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int32) {
        self = .integer(value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension NodeData: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}
