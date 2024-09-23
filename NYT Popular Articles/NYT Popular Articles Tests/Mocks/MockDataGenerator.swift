
import Foundation
@testable import NYT_Popular_Articles

final class MockDataGenerator {
    
    // MARK: - Properties
    
    private var shouldThrowError: Bool

    private lazy var bundle: Bundle = {
        return Bundle(for: type(of: self))
    }()

    // MARK: - Initializer

    init(shouldThrowError: Bool = false) {
        self.shouldThrowError = shouldThrowError
    }

    // MARK: - Functions
    
    func getMockArticles() throws -> [Article]? {
        guard !shouldThrowError,
              let url = bundle.url(forResource: "sampleData", withExtension: "json") else {
            throw NSError.createError(ofType: .noData)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(ArticlesResponse.self, from: data)
        return response.articles
    }
    
    func getMockArticlesData() throws -> Data? {
        guard !shouldThrowError,
              let url = bundle.url(forResource: "sampleData", withExtension: "json") else {
            throw NSError.createError(ofType: .noData)
        }
        
        return try Data(contentsOf: url)
    }
}
