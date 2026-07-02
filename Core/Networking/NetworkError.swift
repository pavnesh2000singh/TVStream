import Foundation

enum NetworkError: Error, Sendable {
    case invalidURL
    case invalidResponse
    case httpStatusCode(Int, Data)
    case decodingFailed
    case timeout
    case cancelled
    case transport(URLError)
    case unknown(any Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpStatusCode(let statusCode, _):
            return "The server returned HTTP status code \(statusCode)."
        case .decodingFailed:
            return "The server response could not be decoded."
        case .timeout:
            return "The request timed out."
        case .cancelled:
            return "The request was cancelled."
        case .transport(let error):
            return error.localizedDescription
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
