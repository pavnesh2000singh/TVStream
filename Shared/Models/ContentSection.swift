import Foundation

struct ContentSection: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let items: [StreamContent]
}
