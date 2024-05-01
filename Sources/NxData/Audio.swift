//
//  Audio.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

/// Nx Audio Data
public struct Audio: Equatable, Hashable, Codable, Sendable, Identifiable {
    
    /// Audio Identifier
    public let id: ID
    
    /// Audio data
    public let data: Data
}

// MARK: - Supporting Types

public extension Audio {
    
    /// Nx Audio ID
    struct ID: RawRepresentable, Equatable, Hashable, Codable, Sendable {
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Audio.ID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt32) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension Audio.ID: CustomStringConvertible {
    
    public var description: String {
        rawValue.description
    }
}
