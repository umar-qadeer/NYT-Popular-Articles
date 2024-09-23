
import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response
}

final class NetworkService: NetworkServiceProtocol {

    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response {

        // Check for network connectivity
        guard Reachability.isConnectedToNetwork() else {
            throw NSError.createNetworkError()
        }

        // Construct URL components
        guard var urlComponent = URLComponents(string: request.url) else {
            throw NSError.createError(ofType: ErrorResponse.invalidEndpoint)
        }

        var queryItems: [URLQueryItem] = []

        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }

        urlComponent.queryItems = queryItems

        guard let url = urlComponent.url else {
            throw NSError.createError(ofType: ErrorResponse.invalidQueryItems)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        // Handle POST request body
        if request.method == .post {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch {
                throw error
            }
        }

        // Perform the network request using async/await
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NSError.createError(ofType: ErrorResponse.invalidResponse)
        }

        // Decode the data
        return try request.decode(data)
    }
}
