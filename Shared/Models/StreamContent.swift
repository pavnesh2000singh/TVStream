import Foundation

struct StreamContent: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let genres: [String]
    let year: Int
    let rating: String
    let runtime: String
    let description: String
    let cast: [String]
    let progress: Double?
    let artworkStyle: ArtworkStyle

    init(
        id: String,
        title: String,
        subtitle: String,
        genres: [String],
        year: Int,
        rating: String,
        runtime: String = "1h 48m",
        description: String,
        cast: [String] = [],
        progress: Double? = nil,
        artworkStyle: ArtworkStyle
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.genres = genres
        self.year = year
        self.rating = rating
        self.runtime = runtime
        self.description = description
        self.cast = cast
        self.progress = progress
        self.artworkStyle = artworkStyle
    }
}

struct ArtworkStyle: Hashable, Sendable {
    let primaryHexColor: String
    let secondaryHexColor: String
    let symbolName: String
}
