import SwiftUI

struct MovieDetailsView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var viewModel: MovieDetailsViewModel
    @State private var didAppear = false

    init(viewModel: MovieDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()

            content
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
            withAnimation(.smooth(duration: 0.45)) {
                didAppear = true
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            MovieDetailsLoadingView()
        case .loaded(let details):
            loadedContent(details)
        case .error(let message):
            MovieDetailsErrorView(message: message) {
                Task {
                    await viewModel.load()
                }
            }
        }
    }

    private func loadedContent(_ details: MovieDetails) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 28) {
                MovieBackdropHeader(
                    movie: details.movie,
                    isInWatchlist: viewModel.isInWatchlist,
                    onPlay: {},
                    onWatchlist: viewModel.toggleWatchlist,
                    onShare: {}
                )

                MovieDescriptionSection(movie: details.movie)

                CastSection(cast: details.cast)

                SimilarMoviesSection(movies: details.similarMovies)
            }
            .padding(.bottom, 48)
            .opacity(didAppear ? 1 : 0)
            .offset(y: didAppear ? 0 : 18)
        }
    }
}

#Preview("Loaded") {
    MovieDetailsView(
        viewModel: MovieDetailsViewModel(
            movieID: "1",
            contentRepository: MockContentRepository(delay: .zero)
        )
    )
    .environment(ThemeManager())
    .environment(AppRouter())
}

#Preview("Loading") {
    MovieDetailsLoadingView()
}
