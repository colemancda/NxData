import XCTest
@testable import NxData

final class NxDataTests: XCTestCase {
    
    func testNxDataHeader() throws {
        
        guard let path = Bundle.module.path(forResource: "Data", ofType: NxFile.fileExtension) else {
            return
        }
        
        let header = try NxData.FileHeader(path: path)
        
        XCTAssertEqual(header.nodeCount, 5686829)
        XCTAssertEqual(header.nodeBlockOffset, 52)
        XCTAssertEqual(header.stringCount, 43081)
        XCTAssertEqual(header.stringOffsetTableOffset, 115612536)
    }
}
