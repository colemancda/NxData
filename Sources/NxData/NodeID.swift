//
//  NodeID.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

public extension Node {
    
    /// Nx File Node ID
    struct ID: RawRepresentable, Equatable, Hashable, Codable, Sendable {
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Node.ID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt32) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension Node.ID: CustomStringConvertible {
    
    public var description: String {
        rawValue.description
    }
}
