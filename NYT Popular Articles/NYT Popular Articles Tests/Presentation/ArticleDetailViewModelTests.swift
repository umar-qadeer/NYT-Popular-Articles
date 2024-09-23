//
//  ArticleDetailViewModelTests.swift
//  NYT Popular Articles Tests
//
//  Created by Muhammad Umar on 23/09/2024.
//

import XCTest
@testable import NYT_Popular_Articles

final class ArticleDetailViewModelTests: XCTestCase {

    func testArticleInitialization() throws {
        // Given & When
        let article = try MockDataGenerator().getMockArticles()?.first
        let viewModel = ArticleDetailViewModel(article: article!)

        // Then
        XCTAssertNotNil(viewModel.article)
        XCTAssertEqual(viewModel.article.title, article?.title)
    }
}
