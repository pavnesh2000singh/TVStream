import Foundation

struct RetryPolicy: Sendable {
    let maxRetries: Int
    let baseDelay: Duration
    let retryableStatusCodes: ClosedRange<Int>

    static let standard = RetryPolicy(
        maxRetries: 2,
        baseDelay: .milliseconds(300),
        retryableStatusCodes: 500...599
    )

    init(
        maxRetries: Int,
        baseDelay: Duration,
        retryableStatusCodes: ClosedRange<Int>
    ) {
        self.maxRetries = max(0, maxRetries)
        self.baseDelay = baseDelay
        self.retryableStatusCodes = retryableStatusCodes
    }

    func shouldRetry(error: NetworkError, attempt: Int) -> Bool {
        guard attempt < maxRetries else { return false }

        switch error {
        case .timeout, .transport:
            return true
        case .httpStatusCode(let statusCode, _):
            return retryableStatusCodes.contains(statusCode)
        case .invalidURL, .invalidResponse, .decodingFailed, .cancelled, .unknown:
            return false
        }
    }

    func delay(for attempt: Int) -> Duration {
        baseDelay * (1 << attempt)
    }
}
