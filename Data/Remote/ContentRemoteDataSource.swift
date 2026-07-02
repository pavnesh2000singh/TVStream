import Foundation

protocol ContentRemoteDataSourceProtocol: Sendable {
    func fetchFeaturedContent() async throws -> [StreamContentDTO]
}

struct ContentRemoteDataSource: ContentRemoteDataSourceProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchFeaturedContent() async throws -> [StreamContentDTO] {
        []
    }
}
