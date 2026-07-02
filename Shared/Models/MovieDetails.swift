import Foundation

struct MovieDetails: Identifiable, Hashable, Sendable {
    let movie: StreamContent
    let cast: [CastMember]
    let similarMovies: [StreamContent]

    var id: String {
        movie.id
    }
}

struct CastMember: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let role: String
    let artworkStyle: ArtworkStyle
}
