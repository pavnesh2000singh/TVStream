import Foundation

protocol APIClientProtocol: Sendable {
    func request<Response: Decodable & Sendable>(
        _ endpoint: any Endpoint,
        as responseType: Response.Type
    ) async throws -> Response
}

struct APIClient: APIClientProtocol {
    private let session: URLSession
    private let requestBuilder: any RequestBuilding
    private let decoderProvider: any JSONDecoderProviding
    private let retryPolicy: RetryPolicy
    private let logger: any NetworkLogging

    init(
        session: URLSession = .shared,
        requestBuilder: any RequestBuilding = RequestBuilder(),
        decoderProvider: any JSONDecoderProviding = JSONDecoderProvider(),
        retryPolicy: RetryPolicy = .standard,
        logger: any NetworkLogging = NetworkLogger()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.decoderProvider = decoderProvider
        self.retryPolicy = retryPolicy
        self.logger = logger
    }

    func request<Response: Decodable & Sendable>(
        _ endpoint: any Endpoint,
        as responseType: Response.Type = Response.self
    ) async throws -> Response {
        let request = try requestBuilder.makeRequest(from: endpoint)
        var attempt = 0

        while true {
            do {
                logger.logRequest(request, attempt: attempt + 1)

                let (data, response) = try await session.data(for: request)
                let httpResponse = try validateHTTPResponse(response, data: data)

                logger.logResponse(httpResponse, data: data)

                if responseType == EmptyResponse.self {
                    guard let emptyResponse = EmptyResponse() as? Response else {
                        throw NetworkError.decodingFailed
                    }
                    return emptyResponse
                }

                do {
                    return try decoderProvider.makeDecoder().decode(responseType, from: data)
                } catch {
                    logger.logError(error)
                    throw NetworkError.decodingFailed
                }
            } catch {
                let networkError = mapError(error)

                guard retryPolicy.shouldRetry(error: networkError, attempt: attempt) else {
                    logger.logError(networkError)
                    throw networkError
                }

                attempt += 1

                do {
                    try await Task.sleep(for: retryPolicy.delay(for: attempt))
                } catch {
                    throw NetworkError.cancelled
                }
            }
        }
    }

    private func validateHTTPResponse(_ response: URLResponse, data: Data) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.httpStatusCode(httpResponse.statusCode, data)
        }

        return httpResponse
    }

    private func mapError(_ error: any Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost, .cannotFindHost:
                return .transport(urlError)
            default:
                return .unknown(urlError)
            }
        }

        if error is CancellationError {
            return .cancelled
        }

        return .unknown(error)
    }
}
