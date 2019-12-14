import XCTest
@testable import SteampressFluentPostgres
import FluentPostgreSQL
import Vapor
import Fluent

class TagRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var app: Application!
    var connection: DatabaseConnectable!
    var repository = FluentPostgresTagRepository()
    
    // MARK: - Overrides
    
    override func setUp() {
        app = try! TestSetup.getApp()
        connection = try! app.requestPooledConnection(to: .psql).wait()
    }
    
    // MARK: - Tests
    
    func testSavingTag() throws {        
        let newTag = try BlogTag(name: "SteamPress")
        let savedTag = try repository.save(newTag, on: app).wait()
        
        XCTAssertNotNil(savedTag.tagID)
        
        let tagFromDB = try BlogTag.query(on: connection).filter(\.tagID == savedTag.tagID).first().wait()
        XCTAssertEqual(tagFromDB?.name, newTag.name)
    }
    
    func testGetingATag() throws {
        let tagName = "Engineering"
        let tag = try BlogTag(name: tagName)
        _ = try tag.save(on: connection).wait()
        
        let retrievedTag = try repository.getTag(tagName, on: app).wait()
        
        XCTAssertEqual(retrievedTag?.name, tagName)
        XCTAssertEqual(retrievedTag?.tagID, tag.tagID)
    }
}
