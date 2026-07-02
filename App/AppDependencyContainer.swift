import Foundation

struct AppDependencyContainer {
    let router: AppRouter
    let themeManager: ThemeManager
    let apiClient: any APIClientProtocol
    let contentRepository: any ContentRepository

    static func live() -> AppDependencyContainer {
        let apiClient = APIClient()
        let contentRepository = MockContentRepository()

        return AppDependencyContainer(
            router: AppRouter(),
            themeManager: ThemeManager(),
            apiClient: apiClient,
            contentRepository: contentRepository
        )
    }
}
