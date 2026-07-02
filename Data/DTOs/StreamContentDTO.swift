import Foundation

struct StreamContentDTO: Decodable, Sendable {
    let id: String
    let title: String
}

extension StreamContentDTO {
    func toDomainModel() -> StreamContent {
        StreamContent(id: id, title: title)
    }
}
