import Foundation
import System

/// NX Data File
///
/// The NX file format was designed with speediness and ease of reading in mind, to speed up loading times for anything that uses a node-tree-based data file format.
///
/// https://nxformat.github.io
public actor NxFile {
    
    public static var fileExtension: String { "nx" }
    
    public nonisolated let path: FilePath
    
    public let handle: FileDescriptor
    
    internal var cache = Cache()
    
    public init(path: FilePath) throws {
        self.handle = try FileDescriptor.open(path, .readOnly, options: [], retryOnInterrupt: true)
        self.path = path
    }
    
    public var header: FileHeader {
        get async throws {
            if let cached = cache.header {
                return cached
            } else {
                guard let header = try await FileHeader(data: data.prefix(FileHeader.length)) else {
                    throw CocoaError(.fileReadCorruptFile)
                }
                cache.header = header
                return header
            }
        }
    }
    
    public var data: Data {
        get async throws {
            if let cached = cache.data {
                return cached
            } else {
                let data = try Data(
                    contentsOf: URL(fileURLWithPath: path.description),
                    options: [.alwaysMapped]
                )
                cache.data = data
                return data
            }
        }
    }
}

internal extension NxFile {
    
    func withFileHandle<Result>(_ block: (FileDescriptor) throws -> (Result)) rethrows -> Result {
        try block(handle)
    }
    
    func read(at offset: Int, into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
        return try handle.read(fromAbsoluteOffset: Int64(offset), into: buffer, retryOnInterrupt: true)
    }
    
    func read<T>(at offset: Int, into value: inout T) throws -> Int {
        try withUnsafeMutableBytes(of: &value) { buffer in
            try handle.read(fromAbsoluteOffset: Int64(offset), into: buffer, retryOnInterrupt: true)
        }
    }
}

// MARK: - Supporting Types

internal extension NxFile {
    
    struct Cache {
        
        var data: Data?
        
        var header: FileHeader?
    }
}
