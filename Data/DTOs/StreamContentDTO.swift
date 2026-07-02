import Foundation

struct StreamContentDTO: Decodable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let genres: [String]?
    let year: Int?
    let rating: String?
    let runtime: String?
    let description: String?
    let cast: [String]?
}

extension StreamContentDTO {
    func toDomainModel() -> StreamContent {
        StreamContent(
            id: id,
            title: title,
            subtitle: subtitle ?? "",
            genres: genres ?? [],
            year: year ?? 0,
            rating: rating ?? "NR",
            runtime: runtime ?? "1h 48m",
            description: description ?? subtitle ?? "",
            cast: cast ?? [],
            artworkStyle: ArtworkStyle(
                primaryHexColor: "2A2F4F",
                secondaryHexColor: "E84545",
                symbolName: "play.rectangle.fill"
            )
        )
    }
}
