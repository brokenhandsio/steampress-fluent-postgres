import XCTest
@testable import SteampressFluentPostgres
import FluentPostgreSQL
import Vapor
import Fluent

class UserRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var app: Application!
    var connection: DatabaseConnectable!
    var repository = FluentPostgresUserRepository()
    
    // MARK: - Overrides
    
    override func setUp() {
        app = try! TestSetup.getApp()
        connection = try! app.requestPooledConnection(to: .psql).wait()
    }
    
    // MARK: - Tests
    
    func testSavingUser() throws {
        let newUser = BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil)
        let savedUser = try repository.save(newUser, on: app).wait()
        
        XCTAssertNotNil(savedUser.userID)
        
        let userFromDB = try BlogUser.query(on: connection).filter(\.userID == savedUser.userID).first().wait()
        XCTAssertEqual(userFromDB?.username, newUser.username)
    }
    
    func testGetingAUserByUsername() throws {
        let username = "alice"
        let newUser = BlogUser(name: "Alice", username: username, password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil)
        _ = try newUser.save(on: connection).wait()

        let retrievedUser = try repository.getUser(username: username, on: app).wait()

        XCTAssertEqual(retrievedUser?.username, username)
        XCTAssertEqual(retrievedUser?.userID, newUser.userID)
    }
    
    func testGettingAUserByID() throws {
        let newUser = try BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        
        let retrievedUser = try repository.getUser(id: newUser.userID!, on: app).wait()
        
        XCTAssertEqual(retrievedUser?.username, newUser.username)
    }
    
    func testGettingAUserByName() throws {
        let name = "Alice"
        let newUser = BlogUser(name: name, username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil)
        _ = try newUser.save(on: connection).wait()

        let retrievedUser = try repository.getUser(name: name, on: app).wait()

        XCTAssertEqual(retrievedUser?.name, name)
        XCTAssertEqual(retrievedUser?.userID, newUser.userID)
    }
    
    func testGettingAllUsers() throws {
        let name1 = "Alice"
        let name2 = "Bob"
        _ = try BlogUser(name: name1, username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        _ = try BlogUser(name: name2, username: "bob", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        
        let users = try repository.getAllUsers(on: app).wait()

        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.name, name1)
        XCTAssertEqual(users.last?.name, name2)
    }
    
    func testUsersCount() throws {
        _ = try BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        _ = try BlogUser(name: "Bob", username: "bob", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        
        let count = try repository.getUsersCount(on: app).wait()
        
        XCTAssertEqual(count, 2)
    }
    
    func testDeletingAUser() throws {
        let user = try BlogUser(name: "Alice", username: "alice", password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        
        let count = try BlogUser.query(on: connection).count().wait()
        XCTAssertEqual(count, 1)
        
        try repository.delete(user, on: app).wait()
        
        let countAfterDelete = try BlogUser.query(on: connection).count().wait()
        XCTAssertEqual(countAfterDelete, 0)
    }
    
    func testCreatingUserWithExistingUsernameFails() throws {
        let username = "alice"
        var errorOccurred = false
        _ = try BlogUser(name: "Alice", username: username, password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        do {
            _ = try BlogUser(name: "Bob", username: username, password: "password", profilePicture: nil, twitterHandle: nil, biography: nil, tagline: nil).save(on: connection).wait()
        } catch {
            errorOccurred = true
        }
        
        XCTAssertTrue(errorOccurred)
    }
}

