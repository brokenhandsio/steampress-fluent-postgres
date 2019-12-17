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
    
    func testErrorOccursWhenSavingATagWithNameThatAlreadyExists() throws {
        let tagName = "SteamPress"
        var errorOccurred = false
        _ = try BlogTag(name: tagName).save(on: connection).wait()
        do {
            _ = try BlogTag(name: tagName).save(on: connection).wait()
        } catch {
            errorOccurred = true
        }
        
        XCTAssertTrue(errorOccurred)
    }
    
    func testAddingTagToPost() throws {
        let tag = try BlogTag(name: "SteamPress").save(on: connection).wait()
        let user = try BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        let post = try BlogPost(title: "A Post", contents: "Some contents", author: user, creationDate: Date(), slugUrl: "a-post", published: true).save(on: connection).wait()
        
        try repository.add(tag, to: post, on: app).wait()
        
        let tagLinks = try BlogPostTagPivot.query(on: connection).all().wait()
        XCTAssertEqual(tagLinks.count, 1)
        XCTAssertEqual(tagLinks.first?.tagID, tag.tagID)
        XCTAssertEqual(tagLinks.first?.postID, post.blogID)
    }
    
    func testRemovingTagFromPost() throws {
        let tag = try BlogTag(name: "SteamPress").save(on: connection).wait()
        let user = try BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        let post = try BlogPost(title: "A Post", contents: "Some contents", author: user, creationDate: Date(), slugUrl: "a-post", published: true).save(on: connection).wait()
        _ = try post.tags.attach(tag, on: connection).wait()
        
        try repository.remove(tag, from: post, on: app).wait()
        
        let tagLinks = try BlogPostTagPivot.query(on: connection).all().wait()
        XCTAssertEqual(tagLinks.count, 0)
    }
}
