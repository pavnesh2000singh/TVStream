import Foundation

struct AppDependencyContainer {
    let router: AppRouter
    let themeManager: ThemeManager
    let contentRepository: any ContentRepository

    static func live() -> AppDependencyContainer {
        let remoteDataSource = ContentRemoteDataSource()

        return AppDependencyContainer(
            router: AppRouter(),
            themeManager: ThemeManager(),
            contentRepository: DefaultContentRepository(remoteDataSource: remoteDataSource)
        )
    }
}
