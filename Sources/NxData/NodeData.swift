//
//  NodeData.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

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
    case bitmap(UInt32)
    
    /// 32-bit unsigned audio ID, followed by 32-bit unsigned data length. Ignored if Audio count in Header is 0.
    case audio(UInt32)
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
