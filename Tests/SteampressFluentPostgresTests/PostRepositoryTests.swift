import XCTest
@testable import SteampressFluentPostgres
import FluentPostgreSQL
import Vapor
import Fluent

class PostRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var app: Application!
    var connection: DatabaseConnectable!
    var repository = FluentPostgresPostRepository()
    var postAuthor: BlogUser!
    
    // MARK: - Overrides
    
    override func setUp() {
        app = try! TestSetup.getApp()
        connection = try! app.requestPooledConnection(to: .psql).wait()
        postAuthor = try! BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
    }
    
    // MARK: - Tests
    
    func testSavingPost() throws {
        let newPost = try BlogPost(title: "A new post", contents: "Some Contents", author: postAuthor, creationDate: Date(), slugUrl: "a-new-post", published: true)
        let savedPost = try repository.save(newPost, on: app).wait()
        
        XCTAssertNotNil(savedPost.blogID)
        
        let postFromDB = try BlogPost.query(on: connection).filter(\.blogID == savedPost.blogID).first().wait()
        XCTAssertEqual(postFromDB?.title, newPost.title)
    }
    
    func testGetingAPost() throws {
//        let tagName = "Engineering"
//        let tag = try BlogTag(name: tagName)
//        _ = try tag.save(on: connection).wait()
//        
//        let retrievedTag = try repository.getTag(tagName, on: app).wait()
//        
//        XCTAssertEqual(retrievedTag?.name, tagName)
//        XCTAssertEqual(retrievedTag?.tagID, tag.tagID)
    }
}

