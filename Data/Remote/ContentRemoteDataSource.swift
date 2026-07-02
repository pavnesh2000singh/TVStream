import Foundation

protocol ContentRemoteDataSourceProtocol: Sendable {
    func fetchFeaturedContent() async throws -> [StreamContentDTO]
}

struct ContentRemoteDataSource: ContentRemoteDataSourceProtocol {
    func fetchFeaturedContent() async throws -> [StreamContentDTO] {
        []
    }
}
