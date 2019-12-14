import XCTest
@testable import SteampressFluentPostgres
import FluentPostgreSQL
import Vapor
import Fluent

class TagRepositoryTests: XCTestCase {
    func testSavingTag() throws {
        
        var services = Services.default()
        try services.register(FluentPostgreSQLProvider())
        
        var databases = DatabasesConfig()
        let hostname: String
        if let envHostname = Environment.get("DB_HOSTNAME") {
            hostname = envHostname
        } else {
            hostname = "localhost"
        }
        let username = "steampress"
        let password = "password"
        let databaseName = "steampress-test"
        let databasePort: Int
        if let envPort = Environment.get("DB_PORT"), let envPortInt = Int(envPort) {
            databasePort = envPortInt
        } else {
            databasePort = 5433
        }
        let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: databasePort, username: username, database: databaseName, password: password)
        let database = PostgreSQLDatabase(config: databaseConfig)
        databases.add(database: database, as: .psql)
        services.register(databases)

        /// Configure migrations
        var migrations = MigrationConfig()
        migrations.add(model: BlogTag.self, database: .psql)
        migrations.add(model: BlogUser.self, database: .psql)
        migrations.add(model: BlogPost.self, database: .psql)
        services.register(migrations)
        
        let config = Config.default()
        
        var commandConfig = CommandConfig.default()
        commandConfig.useFluentCommands()
        services.register(commandConfig)
        
        var revertEnv = Environment.testing
        revertEnv.arguments = ["vapor", "revert", "--all", "-y"]
        _ = try Application(environment: revertEnv, services: services).asyncRun().wait()
        
        let app = try Application(config: config, services: services)
        
        let repository = FluentPostgresTagRepository()
        
        let newTag = try BlogTag(name: "SteamPress")
        let savedTag = try repository.save(newTag, on: app).wait()
        
        XCTAssertNotNil(savedTag.tagID)
        
        let connection = try app.requestPooledConnection(to: .psql).wait()
        let tagFromDB = try BlogTag.query(on: connection).filter(\.tagID == savedTag.tagID).first().wait()
        XCTAssertEqual(tagFromDB?.name, newTag.name)
    }
    
    func testGetingATag() throws {
        var services = Services.default()
        try services.register(FluentPostgreSQLProvider())
        
        var databases = DatabasesConfig()
        let hostname: String
        if let envHostname = Environment.get("DB_HOSTNAME") {
            hostname = envHostname
        } else {
            hostname = "localhost"
        }
        let username = "steampress"
        let password = "password"
        let databaseName = "steampress-test"
        let databasePort: Int
        if let envPort = Environment.get("DB_PORT"), let envPortInt = Int(envPort) {
            databasePort = envPortInt
        } else {
            databasePort = 5433
        }
        let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: databasePort, username: username, database: databaseName, password: password)
        let database = PostgreSQLDatabase(config: databaseConfig)
        databases.add(database: database, as: .psql)
        services.register(databases)

        /// Configure migrations
        var migrations = MigrationConfig()
        migrations.add(model: BlogTag.self, database: .psql)
        migrations.add(model: BlogUser.self, database: .psql)
        migrations.add(model: BlogPost.self, database: .psql)
        services.register(migrations)
        
        let config = Config.default()
        
        var commandConfig = CommandConfig.default()
        commandConfig.useFluentCommands()
        services.register(commandConfig)
        
        var revertEnv = Environment.testing
        revertEnv.arguments = ["vapor", "revert", "--all", "-y"]
        _ = try Application(environment: revertEnv, services: services).asyncRun().wait()
        
        let app = try Application(config: config, services: services)
        let connection = try app.requestPooledConnection(to: .psql).wait()
        
        let repository = FluentPostgresTagRepository()
        
        let tagName = "Engineering"
        let tag = try BlogTag(name: tagName)
        _ = try tag.save(on: connection).wait()
        
        let retrievedTag = try repository.getTag(tagName, on: app).wait()
        
        XCTAssertEqual(retrievedTag?.name, tagName)
        XCTAssertEqual(retrievedTag?.tagID, tag.tagID)
    }
}
