import Observation

protocol ThemeManaging: AnyObject {
    var currentTheme: AppTheme { get set }
}

@MainActor
@Observable
final class ThemeManager: ThemeManaging {
    var currentTheme: AppTheme

    init() {
        self.currentTheme = .standard
    }

    init(currentTheme: AppTheme) {
        self.currentTheme = currentTheme
    }
}
