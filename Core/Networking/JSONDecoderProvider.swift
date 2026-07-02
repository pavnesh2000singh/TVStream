import Foundation

protocol JSONDecoderProviding: Sendable {
    func makeDecoder() -> JSONDecoder
}

struct JSONDecoderProvider: JSONDecoderProviding {
    private let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    private let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy

    init(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
    }

    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        return decoder
    }
}
