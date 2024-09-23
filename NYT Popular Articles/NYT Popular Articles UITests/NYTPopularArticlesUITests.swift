
import XCTest
@testable import NYT_Popular_Articles

class NYTPopularArticlesUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testArticleCellTapNavigatesToDetailScreenDisplaysCorrectTitle() {
        let app = XCUIApplication()
        let tableViewsQuery = app.tables
        let articleCell = tableViewsQuery.cells[AccessibilityIdentifier.articleCellIdentifier].firstMatch
        let articleCellExists = articleCell.waitForExistence(timeout: 2.0)

        XCTAssertTrue(articleCellExists)

        articleCell.tap()

        // Check if navigation succeeded by verifying the screen title
        let navigationBar = app.navigationBars[Strings.Titles.articleDetails]
        let titleExists = navigationBar.waitForExistence(timeout: 2.0)

        XCTAssertTrue(titleExists, "Detail screen title should be 'Article Details'")
    }
}
