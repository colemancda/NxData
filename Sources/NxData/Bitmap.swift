//
//  Bitmap.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

/// Nx Bitmap Data
public struct Bitmap: Equatable, Hashable, Codable, Sendable {
    
    /// Bitmap Identifier
    public let id: ID
    
    /// Bitmap compressed data
    public let data: Data
}

// MARK: - Supporting Types

public extension Bitmap {
    
    /// Nx Bitmap ID
    struct ID: RawRepresentable, Equatable, Hashable, Codable, Sendable {
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Bitmap.ID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt32) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension Bitmap.ID: CustomStringConvertible {
    
    public var description: String {
        rawValue.description
    }
}
