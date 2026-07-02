import Foundation

protocol ContentRepository: Sendable {
    func fetchFeaturedContent() async throws -> [StreamContent]
    func fetchHomeSections() async throws -> [ContentSection]
    func fetchMovieDetails(id: String) async throws -> MovieDetails
    func fetchSimilarMovies(for id: String) async throws -> [StreamContent]
    func searchContent(query: String) async throws -> [StreamContent]
    func fetchSearchSuggestions(query: String) async throws -> [String]
    func fetchTrendingKeywords() async throws -> [String]
}
