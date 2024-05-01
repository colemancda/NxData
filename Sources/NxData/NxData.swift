import Foundation
import SystemPackage

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
    
    /// Initialize from file path.
    public init(path: FilePath) throws {
        self.handle = try FileDescriptor.open(path, .readOnly, options: [], retryOnInterrupt: true)
        self.path = path
    }
    
    deinit {
        try? handle.close()
    }
    
    /// File Header
    public var header: FileHeader {
        get async throws {
            if let cached = cache.header {
                return cached
            } else {
                let header = try FileHeader(file: handle)
                cache.header = header
                return header
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
                
        var header: FileHeader?
    }
}
