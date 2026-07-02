import SwiftUI

@main
struct TVStreamApp: App {
    @State private var dependencies = AppDependencyContainer.live()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dependencies.router)
                .environment(dependencies.themeManager)
        }
    }
}
