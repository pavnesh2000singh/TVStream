import SwiftUI

struct SearchView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var viewModel: SearchViewModel
    @FocusState private var isSearchFocused: Bool

    init(viewModel: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 24) {
                    SearchBar(
                        text: $viewModel.query,
                        isFocused: $isSearchFocused,
                        onSubmit: viewModel.submitSearch,
                        onClear: viewModel.clearQuery
                    )
                    .padding(.horizontal, SearchLayout.horizontalPadding)
                    .padding(.top, 18)

                    suggestionsContent

                    searchStateContent
                }
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var suggestionsContent: some View {
        if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            SearchKeywordSection(
                title: "Recent Searches",
                keywords: viewModel.recentSearches,
                showsClearButton: !viewModel.recentSearches.isEmpty,
                onClear: viewModel.clearRecentSearches,
                onSelect: viewModel.selectKeyword
            )

            SearchKeywordSection(
                title: "Trending",
                keywords: viewModel.trendingKeywords,
                onSelect: viewModel.selectKeyword
            )
        } else if !viewModel.suggestions.isEmpty {
            SearchSuggestionsList(
                suggestions: viewModel.suggestions,
                onSelect: viewModel.selectKeyword
            )
        }
    }

    @ViewBuilder
    private var searchStateContent: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            SearchLoadingGrid()
        case .results(let results):
            SearchResultsGrid(results: results)
        case .empty(let query):
            SearchEmptyView(query: query)
        case .error(let message):
            SearchErrorView(message: message)
        }
    }
}

#Preview("Search") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(contentRepository: MockContentRepository(delay: .zero)))
            .environment(ThemeManager())
            .environment(AppRouter())
    }
}
