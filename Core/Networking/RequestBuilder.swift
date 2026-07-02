import Foundation

protocol RequestBuilding: Sendable {
    func makeRequest(from endpoint: any Endpoint) throws -> URLRequest
}

struct RequestBuilder: RequestBuilding {
    func makeRequest(from endpoint: any Endpoint) throws -> URLRequest {
        let url = try makeURL(from: endpoint)
        var request = URLRequest(url: url, timeoutInterval: endpoint.timeoutInterval)

        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers.forEach { header, value in
            request.setValue(value, forHTTPHeaderField: header)
        }

        if endpoint.body != nil, request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if request.value(forHTTPHeaderField: "Accept") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }

        return request
    }

    private func makeURL(from endpoint: any Endpoint) throws -> URL {
        let path = endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = endpoint.baseURL.appending(path: path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }

        return finalURL
    }
}
