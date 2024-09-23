
import XCTest
@testable import NYT_Popular_Articles

final class ArticleModelTests: XCTestCase {

    func testArticleInitialization() throws {
        // Given & When
        let articles = try MockDataGenerator().getMockArticles()

        // Then
        XCTAssertNotNil(articles?.first)
        XCTAssertEqual(articles?.first?.title, "I’m the Republican Governor of Ohio. Here Is the Truth About Springfield.")
    }
}
