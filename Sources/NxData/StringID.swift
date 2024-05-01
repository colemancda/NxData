//
//  StringID.swift
//
//
//  Created by Alsey Coleman Miller on 5/1/24.
//

import Foundation

/// Nx String ID
public struct StringID: RawRepresentable, Equatable, Hashable, Codable, Sendable {
    
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension StringID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt32) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension StringID: CustomStringConvertible {
    
    public var description: String {
        rawValue.description
    }
}
