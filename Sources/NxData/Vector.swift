//
//  Vector.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

/// Nx Vector Data
///
/// Two 32-bit signed integers (Int32), for X and Y respectively.
public struct Vector: Equatable, Hashable, Codable, Sendable {
    
    /// X vector
    public var x: Int32
    
    /// Y vector
    public var y: Int32
}
