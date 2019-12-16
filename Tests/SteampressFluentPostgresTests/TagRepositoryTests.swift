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
    
    func testGettingAllTags() throws {
        let tagName1 = "Engineering"
        let tagName2 = "SteamPress"
        _ = try BlogTag(name: tagName1).save(on: connection).wait()
        _ = try BlogTag(name: tagName2).save(on: connection).wait()
        
        let tags = try repository.getAllTags(on: app).wait()
        
        XCTAssertEqual(tags.count, 2)
        XCTAssertEqual(tags.first?.name, tagName1)
        XCTAssertEqual(tags.last?.name, tagName2)
    }
    
    #warning("Test tag name must be unique")
}
