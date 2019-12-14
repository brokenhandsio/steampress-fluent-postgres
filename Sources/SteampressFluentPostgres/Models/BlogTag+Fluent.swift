import FluentPostgreSQL
import SteamPress

extension BlogTag: Model {
    public typealias ID = Int
    public typealias Database = PostgreSQLDatabase
    public static var idKey: IDKey { return \.tagID }
}

extension BlogTag: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Database.create(BlogTag.self, on: connection) { builder in
            builder.field(for: \.tagID, isIdentifier: true)
            builder.field(for: \.name)
            builder.unique(on: \.name)
        }
    }
}