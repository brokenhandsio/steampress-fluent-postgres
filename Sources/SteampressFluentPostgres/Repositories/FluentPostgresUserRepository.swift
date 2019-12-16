import FluentPostgreSQL
import SteamPress

struct FluentPostgresUserRepository: BlogUserRepository {
    func getAllUsers(on container: Container) -> EventLoopFuture<[BlogUser]> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogUser.query(on: connection).all()
        }
    }
    
    func getAllUsersWithPostCount(on container: Container) -> EventLoopFuture<[(BlogUser, Int)]> {
        fatalError()
    }
    
    func getUser(id: Int, on container: Container) -> EventLoopFuture<BlogUser?> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogUser.query(on: connection).filter(\.userID == id).first()
        }
    }
    
    func getUser(name: String, on container: Container) -> EventLoopFuture<BlogUser?> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogUser.query(on: connection).filter(\.name == name).first()
        }
    }
    
    func getUser(username: String, on container: Container) -> EventLoopFuture<BlogUser?> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogUser.query(on: connection).filter(\.username == username).first()
        }
    }
    
    func save(_ user: BlogUser, on container: Container) -> EventLoopFuture<BlogUser> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            user.save(on: connection)
        }
    }
    
    func delete(_ user: BlogUser, on container: Container) -> EventLoopFuture<Void> {
        fatalError()
    }
    
    func getUsersCount(on container: Container) -> EventLoopFuture<Int> {
        fatalError()
    }
    
    
}
