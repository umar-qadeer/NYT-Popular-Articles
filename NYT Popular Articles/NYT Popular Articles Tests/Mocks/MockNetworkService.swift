
import XCTest
@testable import NYT_Popular_Articles

final class MockNetworkService: NetworkServiceProtocol {

    private var shouldThrowError: Bool
    private let mockDataGenerator = MockDataGenerator()

    init(shouldThrowError: Bool) {
        self.shouldThrowError = shouldThrowError
    }

    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response {

        if shouldThrowError {
            throw NSError.createError(domain: "Mock Error", code: 0, message: nil)
        }

        if let data = try mockDataGenerator.getMockArticlesData() {
            return try request.decode(data)
        }

        throw NSError.createError(domain: "Mock Error", code: 0, message: nil)
    }
}
