
import XCTest
@testable import NYT_Popular_Articles

final class MockArticlesRepository: ArticlesRepositoryProtocol {

    private var shouldThrowError: Bool
    private let mockDataGenerator = MockDataGenerator()

    init(shouldThrowError: Bool) {
        self.shouldThrowError = shouldThrowError
    }

    func fetchArticles() async throws -> [Article]? {
        if shouldThrowError {
            throw NSError.createError(domain: "Mock Error", code: 0, message: nil)
        }

        return try MockDataGenerator().getMockArticles()
    }
}
