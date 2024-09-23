
import Foundation
import Combine

final class ArticlesViewModel {
    
    // MARK: - Properties
    
    @Published var articles: [Article]?
    @Published var isLoading: Bool = false
    @Published var error: Error?

    private let articlesRepository: ArticlesRepositoryProtocol?

    // MARK: - Initializers
    
    init(articlesRepository: ArticlesRepositoryProtocol) {
        self.articlesRepository = articlesRepository
    }
    
    // MARK: - Functions
    
    func fetchArticles() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let articles = try await articlesRepository?.fetchArticles()
                self.articles = articles
            } catch {
                self.error = error
            }
        }
    }
}
