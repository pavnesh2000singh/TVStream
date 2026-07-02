import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailsViewModel: ViewModel {
    private let movieID: String
    private let contentRepository: any ContentRepository

    private(set) var state: MovieDetailsViewState = .loading
    var isInWatchlist = false

    init(movieID: String, contentRepository: any ContentRepository) {
        self.movieID = movieID
        self.contentRepository = contentRepository
    }

    func load() async {
        state = .loading

        do {
            let details = try await contentRepository.fetchMovieDetails(id: movieID)
            state = .loaded(details)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func toggleWatchlist() {
        isInWatchlist.toggle()
    }
}

enum MovieDetailsViewState: Equatable {
    case loading
    case loaded(MovieDetails)
    case error(String)
}
