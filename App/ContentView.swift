import SwiftUI

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            EmptyRootView()
                .background(themeManager.currentTheme.colors.background.ignoresSafeArea())
        }
        .tint(themeManager.currentTheme.colors.accent)
    }
}

#Preview {
    ContentView()
        .environment(AppRouter())
        .environment(ThemeManager())
}
