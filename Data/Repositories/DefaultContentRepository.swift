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
}
