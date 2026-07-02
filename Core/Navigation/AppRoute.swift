import Foundation

enum AppRoute: Hashable, Sendable {
    case movieDetails(id: String)
    case search
}
