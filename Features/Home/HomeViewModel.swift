import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel: ViewModel {
    private let contentRepository: any ContentRepository

    private(set) var state: HomeViewState = .loading

    init(contentRepository: any ContentRepository) {
        self.contentRepository = contentRepository
    }

    var heroContent: StreamContent? {
        guard case .loaded(let sections) = state else { return nil }
        return sections.first?.items.first
    }

    var contentSections: [ContentSection] {
        guard case .loaded(let sections) = state else { return [] }
        return sections
    }

    func load() async {
        state = .loading

        do {
            let sections = try await contentRepository.fetchHomeSections()
            state = sections.isEmpty ? .empty : .loaded(sections)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

enum HomeViewState: Equatable {
    case loading
    case loaded([ContentSection])
    case empty
    case error(String)
}
