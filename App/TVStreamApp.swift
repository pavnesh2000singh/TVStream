import SwiftUI

@main
struct TVStreamApp: App {
    @State private var dependencies = AppDependencyContainer.live()

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies)
                .environment(dependencies.router)
                .environment(dependencies.themeManager)
        }
    }
}
