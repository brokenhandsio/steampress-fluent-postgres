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
    
    func testDeletingAPost() throws {
        let post = try BlogPost(title: "A new post", contents: "Some Contents", author: postAuthor, creationDate: Date(), slugUrl: "a-new-post", published: true).save(on: connection).wait()
        
        let initialCount = try BlogPost.query(on: connection).count().wait()
        XCTAssertEqual(initialCount, 1)
        
        try repository.delete(post, on: app).wait()
        
        let count = try BlogPost.query(on: connection).count().wait()
        XCTAssertEqual(count, 0)
    }
    
    func testGetingAPostById() throws {
        let post = try BlogPost(title: "A new post", contents: "Some Contents", author: postAuthor, creationDate: Date(), slugUrl: "a-new-post", published: true).save(on: connection).wait()
        
        let retrievedPost = try repository.getPost(id: post.blogID!, on: app).wait()
        
        XCTAssertEqual(retrievedPost?.title, post.title)
    }
    
    func testGettingAPostBySlugURL() throws {
        let slugURL = "a-new-post"
        let post = try BlogPost(title: "A new post", contents: "Some Contents", author: postAuthor, creationDate: Date(), slugUrl: slugURL, published: true).save(on: connection).wait()
        
        let retrievedPost = try repository.getPost(slug: slugURL, on: app).wait()
        
        XCTAssertEqual(retrievedPost?.blogID, post.blogID)
        XCTAssertEqual(post.title, retrievedPost?.title)
    }
    
    func testSlugURLMustBeUnique() throws {
        let slugURL = "a-new-post"
        _ = try BlogPost(title: "A new post", contents: "Some Contents", author: postAuthor, creationDate: Date(), slugUrl: slugURL, published: true).save(on: connection).wait()
        var errorOccurred = false
        do {
            _ = try BlogPost(title: "A different post", contents: "Some other contents", author: postAuthor, creationDate: Date(), slugUrl: slugURL, published: true).save(on: connection).wait()
        } catch {
            errorOccurred = true
        }
        
        XCTAssertTrue(errorOccurred)
    }
    
    func testUserMustExistInDBWhenSavingPost() throws {
        let unsavedUser = BlogUser(userID: 99, name: "Bob", username: "bob", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil)
        var errorOccurred = false
        do {
            _ = try BlogPost(title: "A new post", contents: "Some contents", author: unsavedUser, creationDate: Date(), slugUrl: "a-new-post", published: true).save(on: connection).wait()
        } catch {
            errorOccurred = true
        }
        
        XCTAssertTrue(errorOccurred)
    }
}

