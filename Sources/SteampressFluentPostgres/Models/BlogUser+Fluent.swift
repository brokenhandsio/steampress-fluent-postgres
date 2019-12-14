import SteamPress
import FluentPostgreSQL

extension BlogUser: Model {
    public typealias ID = Int
    public typealias Database = PostgreSQLDatabase
    public static var idKey: IDKey { return \.userID }
}

extension BlogUser: Migration {}
