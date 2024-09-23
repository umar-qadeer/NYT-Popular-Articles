
import XCTest
import Combine
@testable import NYT_Popular_Articles

final class ArticlesViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testFetchArticlesSuccess() async {
        // Given
        let mockRepository = MockArticlesRepository(shouldThrowError: false)
        let viewModel = ArticlesViewModel(articlesRepository: mockRepository)

        let expectation = XCTestExpectation(description: "Fetch articles successfully")

        // When
        viewModel.$articles
            .dropFirst()
            .sink { articles in
                XCTAssertNotNil(articles)
                XCTAssertEqual(articles?.count, 20)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchArticles()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testFetchArticlesFailure() async {
        // Given
        let mockRepository = MockArticlesRepository(shouldThrowError: true)
        let viewModel = ArticlesViewModel(articlesRepository: mockRepository)

        let expectation = XCTestExpectation(description: "Fetch articles failure")

        // When
        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchArticles()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
