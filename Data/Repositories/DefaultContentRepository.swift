import Foundation

struct DefaultContentRepository: ContentRepository {
    private let remoteDataSource: any ContentRemoteDataSourceProtocol

    init(remoteDataSource: any ContentRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchFeaturedContent() async throws -> [StreamContent] {
        let content = try await remoteDataSource.fetchFeaturedContent()
        return content.map { $0.toDomainModel() }
    }

    func fetchHomeSections() async throws -> [ContentSection] {
        []
    }

    func fetchMovieDetails(id: String) async throws -> MovieDetails {
        throw NetworkError.invalidResponse
    }

    func fetchSimilarMovies(for id: String) async throws -> [StreamContent] {
        []
    }

    func searchContent(query: String) async throws -> [StreamContent] {
        []
    }

    func fetchSearchSuggestions(query: String) async throws -> [String] {
        []
    }

    func fetchTrendingKeywords() async throws -> [String] {
        []
    }
}
