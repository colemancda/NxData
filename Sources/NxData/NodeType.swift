//
//  NodeDataType.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

/// Nx Node Data Type
public enum NodeDataType: UInt16, Codable, CaseIterable, Sendable {
    
    /// No data
    ///
    /// This field is ignored.
    case none       = 0
    
    /// 64-bit signed integer.
    case integer    = 1
    
    /// 64-bit IEEE double-precision floating point.
    case double     = 2
    
    /// 32-bit unsigned string ID.
    case string     = 3
    
    /// Two 32-bit signed integers (Int32), for X and Y respectively.
    case vector     = 4
    
    /// 32-bit unsigned bitmap ID, followed by 16-bit unsigned width and height in that order. Ignored if Bitmap count in Header is 0.
    case bitmap     = 5
    
    /// 32-bit unsigned audio ID, followed by 32-bit unsigned data length. Ignored if Audio count in Header is 0.
    case audio      = 6
}
