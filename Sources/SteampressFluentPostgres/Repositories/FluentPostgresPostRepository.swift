import FluentPostgreSQL
import SteamPress

struct FluentPostgresPostRepository: BlogPostRepository {
    
    func getAllPostsSortedByPublishDate(includeDrafts: Bool, on container: Container) -> EventLoopFuture<[BlogPost]> {
        container.future([])
    }
    
    func getAllPostsSortedByPublishDate(includeDrafts: Bool, on container: Container, count: Int, offset: Int) -> EventLoopFuture<[BlogPost]> {
        container.future([])
    }
    
    func getAllPostsSortedByPublishDate(for user: BlogUser, includeDrafts: Bool, on container: Container, count: Int, offset: Int) -> EventLoopFuture<[BlogPost]> {
        container.future([])
    }
    
    func getPostCount(for user: BlogUser, on container: Container) -> EventLoopFuture<Int> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            try user.posts.query(on: connection).filter(\.published == true).count()
        }
    }
    
    func getPost(slug: String, on container: Container) -> EventLoopFuture<BlogPost?> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogPost.query(on: connection).filter(\.slugUrl == slug).first()
        }
    }
    
    func getPost(id: Int, on container: Container) -> EventLoopFuture<BlogPost?> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            BlogPost.query(on: connection).filter(\.blogID == id).first()
        }
    }
    
    func getSortedPublishedPosts(for tag: BlogTag, on container: Container, count: Int, offset: Int) -> EventLoopFuture<[BlogPost]> {
        container.future([])
    }
    
    func findPublishedPostsOrdered(for searchTerm: String, on container: Container) -> EventLoopFuture<[BlogPost]> {
        container.future([])
    }
    
    func save(_ post: BlogPost, on container: Container) -> EventLoopFuture<BlogPost> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            post.save(on: connection)
        }
    }
    
    func delete(_ post: BlogPost, on container: Container) -> EventLoopFuture<Void> {
        container.requestPooledConnection(to: .psql).flatMap { connection in
            post.delete(on: connection)
        }
    }
    
}

