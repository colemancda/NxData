import Foundation

/// NX Data File
///
/// The NX file format was designed with speediness and ease of reading in mind, to speed up loading times for anything that uses a node-tree-based data file format.
///
/// https://nxformat.github.io
public actor NxFile {
    
    public static var fileExtension: String { "nx" }
    
    public let path: String
    
    internal var cache = Cache()
    
    public init(path: String) {
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
                    contentsOf: URL(fileURLWithPath: path),
                    options: [.alwaysMapped]
                )
                cache.data = data
                return data
            }
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
