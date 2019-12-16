import FluentPostgreSQL
import SteamPress

struct FluentPostgresTagRepository: BlogTagRepository {
    
    func getAllTags(on container: Container) -> EventLoopFuture<[BlogTag]> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogTag.query(on: connection).all()
        }
    }
    
    func getAllTagsWithPostCount(on container: Container) -> EventLoopFuture<[(BlogTag, Int)]> {
        fatalError()
    }
    
    func getTags(for post: BlogPost, on container: Container) -> EventLoopFuture<[BlogTag]> {
        fatalError()
    }
    
    func getTag(_ name: String, on container: Container) -> EventLoopFuture<BlogTag?> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogTag.query(on: connection).filter(\.name == name).first()
        }
    }
    
    func save(_ tag: BlogTag, on container: Container) -> EventLoopFuture<BlogTag> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            tag.save(on: connection)
        }
    }
    
    func deleteTags(for post: BlogPost, on container: Container) -> EventLoopFuture<Void> {
        fatalError()
    }
    
    func remove(_ tag: BlogTag, from post: BlogPost, on container: Container) -> EventLoopFuture<Void> {
        fatalError()
    }
    
    func add(_ tag: BlogTag, to post: BlogPost, on conainter: Container) -> EventLoopFuture<Void> {
        fatalError()
    }
    
    
}
