import SteamPress
import FluentPostgreSQL

extension BlogPost: Model {
    public typealias ID = Int
    public typealias Database = PostgreSQLDatabase
    public static var idKey: IDKey { return \.blogID }
}

extension BlogPost: Migration {}
