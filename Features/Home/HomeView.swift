import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(ThemeManager.self) private var themeManager
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()

            content
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.navigate(to: .search)
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel("Search")
            }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            HomeLoadingView()
        case .loaded:
            loadedContent
        case .empty:
            HomeEmptyView()
        case .error(let message):
            HomeErrorView(message: message) {
                Task {
                    await viewModel.load()
                }
            }
        }
    }

    private var loadedContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 34) {
                if let heroContent = viewModel.heroContent {
                    HeroBanner(content: heroContent)
                }

                ForEach(viewModel.contentSections) { section in
                    ContentRail(section: section)
                }
            }
            .padding(.bottom, 48)
        }
    }
}

#Preview("Loaded") {
    HomeView(viewModel: HomeViewModel(contentRepository: MockContentRepository(delay: .zero)))
        .environment(ThemeManager())
}

#Preview("Empty") {
    HomeView(viewModel: HomeViewModel(contentRepository: MockContentRepository(delay: .zero, shouldReturnEmpty: true)))
        .environment(ThemeManager())
}

#Preview("Error") {
    HomeView(viewModel: HomeViewModel(contentRepository: MockContentRepository(delay: .zero, shouldFail: true)))
        .environment(ThemeManager())
}
