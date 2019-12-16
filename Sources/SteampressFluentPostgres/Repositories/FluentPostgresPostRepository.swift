import FluentPostgreSQL
import SteamPress

struct FluentPostgresPostRepository: BlogPostRepository {
    
    func getAllPostsSortedByPublishDate(includeDrafts: Bool, on container: Container) -> EventLoopFuture<[BlogPost]> {
        fatalError()
    }
    
    func getAllPostsSortedByPublishDate(includeDrafts: Bool, on container: Container, count: Int, offset: Int) -> EventLoopFuture<[BlogPost]> {
        fatalError()
    }
    
    func getAllPostsSortedByPublishDate(for user: BlogUser, includeDrafts: Bool, on container: Container, count: Int, offset: Int) -> EventLoopFuture<[BlogPost]> {
        fatalError()
    }
    
    func getPostCount(for user: BlogUser, on container: Container) -> EventLoopFuture<Int> {
        fatalError()
    }
    
    func getPost(slug: String, on container: Container) -> EventLoopFuture<BlogPost?> {
        fatalError()
    }
    
    func getPost(id: Int, on container: Container) -> EventLoopFuture<BlogPost?> {
        fatalError()
    }
    
    func getSortedPublishedPosts(for tag: BlogTag, on container: Container, count: Int, offset: Int) -> EventLoopFuture<[BlogPost]> {
        fatalError()
    }
    
    func findPublishedPostsOrdered(for searchTerm: String, on container: Container) -> EventLoopFuture<[BlogPost]> {
        fatalError()
    }
    
    func save(_ post: BlogPost, on container: Container) -> EventLoopFuture<BlogPost> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            post.save(on: connection)
        }
    }
    
    func delete(_ post: BlogPost, on container: Container) -> EventLoopFuture<Void> {
        fatalError()
    }
    
}

