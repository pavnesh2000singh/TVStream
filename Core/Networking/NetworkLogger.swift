import Foundation
import os

protocol NetworkLogging: Sendable {
    func logRequest(_ request: URLRequest, attempt: Int)
    func logResponse(_ response: HTTPURLResponse, data: Data)
    func logError(_ error: any Error)
}

struct NetworkLogger: NetworkLogging {
    private let logger: Logger

    init(logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "TVStream", category: "Networking")) {
        self.logger = logger
    }

    func logRequest(_ request: URLRequest, attempt: Int) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "nil"
        logger.debug("Request attempt \(attempt, privacy: .public): \(method, privacy: .public) \(url, privacy: .public)")
    }

    func logResponse(_ response: HTTPURLResponse, data: Data) {
        logger.debug("Response \(response.statusCode, privacy: .public), \(data.count, privacy: .public) bytes")
    }

    func logError(_ error: any Error) {
        logger.error("Network error: \(error.localizedDescription, privacy: .public)")
    }
}

struct NoOpNetworkLogger: NetworkLogging {
    func logRequest(_ request: URLRequest, attempt: Int) {
    }

    func logResponse(_ response: HTTPURLResponse, data: Data) {
    }

    func logError(_ error: any Error) {
    }
}
