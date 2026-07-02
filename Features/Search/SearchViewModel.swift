import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel: ViewModel {
    private let contentRepository: any ContentRepository
    private var searchTask: Task<Void, Never>?

    var query = "" {
        didSet {
            scheduleSearch()
        }
    }

    private(set) var state: SearchViewState = .idle
    private(set) var recentSearches: [String] = []
    private(set) var trendingKeywords: [String] = []
    private(set) var suggestions: [String] = []

    init(contentRepository: any ContentRepository) {
        self.contentRepository = contentRepository
    }

    func load() async {
        do {
            trendingKeywords = try await contentRepository.fetchTrendingKeywords()
        } catch {
            trendingKeywords = []
        }
    }

    func submitSearch() {
        let normalizedQuery = normalizedQuery(query)
        guard !normalizedQuery.isEmpty else { return }

        addRecentSearch(normalizedQuery)
        searchTask?.cancel()
        searchTask = Task {
            await performSearch(for: normalizedQuery)
        }
    }

    func selectKeyword(_ keyword: String) {
        query = keyword
        submitSearch()
    }

    func clearQuery() {
        query = ""
        suggestions = []
        state = .idle
    }

    func removeRecentSearch(_ keyword: String) {
        recentSearches.removeAll { $0 == keyword }
    }

    func clearRecentSearches() {
        recentSearches.removeAll()
    }

    private func scheduleSearch() {
        searchTask?.cancel()

        let normalizedQuery = normalizedQuery(query)
        guard !normalizedQuery.isEmpty else {
            suggestions = []
            state = .idle
            return
        }

        state = .loading

        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(350))
                await performSearch(for: normalizedQuery)
            } catch {
                if error is CancellationError {
                    return
                }

                state = .error(error.localizedDescription)
            }
        }
    }

    private func performSearch(for query: String) async {
        do {
            async let results = contentRepository.searchContent(query: query)
            async let searchSuggestions = contentRepository.fetchSearchSuggestions(query: query)

            let loadedResults = try await results
            suggestions = try await searchSuggestions
            state = loadedResults.isEmpty ? .empty(query) : .results(loadedResults)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func addRecentSearch(_ keyword: String) {
        recentSearches.removeAll { $0.caseInsensitiveCompare(keyword) == .orderedSame }
        recentSearches.insert(keyword, at: 0)
        recentSearches = Array(recentSearches.prefix(6))
    }

    private func normalizedQuery(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum SearchViewState: Equatable {
    case idle
    case loading
    case results([StreamContent])
    case empty(String)
    case error(String)
}
