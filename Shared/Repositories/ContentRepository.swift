import Foundation

protocol ContentRepository: Sendable {
    func fetchFeaturedContent() async throws -> [StreamContent]
}
