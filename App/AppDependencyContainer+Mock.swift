import Foundation

extension AppDependencyContainer {
    static func mock(
        contentRepository: any ContentRepository = MockContentRepository(delay: .zero)
    ) -> AppDependencyContainer {
        let apiClient = APIClient(logger: NoOpNetworkLogger())

        return AppDependencyContainer(
            router: AppRouter(),
            themeManager: ThemeManager(),
            apiClient: apiClient,
            contentRepository: contentRepository
        )
    }
}
