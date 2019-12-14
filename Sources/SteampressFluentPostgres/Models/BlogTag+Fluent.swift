import FluentPostgreSQL
import SteamPress

extension BlogTag: Model {
    public typealias ID = Int
    public typealias Database = PostgreSQLDatabase
    public static var idKey: IDKey { return \.tagID }
}

extension BlogTag: Migration {}
