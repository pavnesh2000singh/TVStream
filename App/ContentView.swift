import SwiftUI

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(ThemeManager.self) private var themeManager
    private let dependencies: AppDependencyContainer

    init(dependencies: AppDependencyContainer) {
        self.dependencies = dependencies
    }

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            HomeView(viewModel: HomeViewModel(contentRepository: dependencies.contentRepository))
                .background(themeManager.currentTheme.colors.background.ignoresSafeArea())
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .tint(themeManager.currentTheme.colors.accent)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .movieDetails(let id):
            MovieDetailsView(
                viewModel: MovieDetailsViewModel(
                    movieID: id,
                    contentRepository: dependencies.contentRepository
                )
            )
        case .search:
            SearchView(
                viewModel: SearchViewModel(
                    contentRepository: dependencies.contentRepository
                )
            )
        }
    }
}

#Preview {
    ContentView(dependencies: .mock())
        .environment(AppRouter())
        .environment(ThemeManager())
}
