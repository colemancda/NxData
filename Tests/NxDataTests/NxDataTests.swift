import Foundation
import XCTest
import System
@testable import NxData

final class NxDataTests: XCTestCase {
    
    let path = Bundle.module.path(forResource: "Data", ofType: NxFile.fileExtension)
    
    func testNxDataHeader() throws {
        
        guard let path else {
            return
        }
        
        let header = try NxData.FileHeader(path: path)
        
        XCTAssertEqual(header.nodeCount, 5686829)
        XCTAssertEqual(header.nodeBlockOffset, 52)
        XCTAssertEqual(header.stringCount, 43081)
        XCTAssertEqual(header.stringOffsetTableOffset, 115612536)
    }
    
    func testStrings() async throws {
        
        guard let path else {
            return
        }
        
        let file = try NxFile(path: FilePath(path))
        
        let stringCount = try await file.string.count
        XCTAssertEqual(stringCount, 43081)
        
        let img0001 = try await file.string[1]
        XCTAssertEqual(img0001, "0001.img")
        
        let strings = try await Array(file.string.prefix(10))
        XCTAssertEqual(strings.count, 10)
        strings.forEach {
            print($0)
        }
    }
}
