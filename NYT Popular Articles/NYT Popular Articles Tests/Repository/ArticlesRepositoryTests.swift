
import XCTest
@testable import NYT_Popular_Articles

final class ArticlesRepositoryTests: XCTestCase {

    func testFetchArticlesSuccess() async throws {
        // Given
        let mockNetworkService = MockNetworkService(shouldThrowError: false)
        let repository = ArticlesRepository(networkService: mockNetworkService)

        // When
        let articles = try await repository.fetchArticles()

        // Then
        XCTAssertNotNil(articles)
        XCTAssertEqual(articles?.count, 20)
    }

    func testFetchArticlesFailure() async {
        // Given
        let mockNetworkService = MockNetworkService(shouldThrowError: true)
        let repository = ArticlesRepository(networkService: mockNetworkService)

        // When and Then
        do {
            _ = try await repository.fetchArticles()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
